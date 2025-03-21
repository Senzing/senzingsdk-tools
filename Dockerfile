ARG BASE_IMAGE=senzing/senzingsdk-runtime

# Create the runtime image.

ARG SENZING_ACCEPT_EULA="I_ACCEPT_THE_SENZING_EULA"
ARG SENZING_APT_INSTALL_TOOLS_PACKAGE="senzingsdk-tools"

# -----------------------------------------------------------------------------
# Stage: builder
# -----------------------------------------------------------------------------

FROM ${BASE_IMAGE} AS builder

ENV REFRESHED_AT=2024-12-06

# Run as "root" for system installation.

USER root

# Install packages via apt-get.

RUN apt-get update \
  && apt-get -y install \
  python3 \
  python3-dev \
  python3-pip \
  python3-venv \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Create and activate virtual environment.
RUN python3 -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

# Install packages via PIP.

COPY requirements.txt .
RUN pip3 install --upgrade pip \
  && pip3 install -r requirements.txt \
  && rm requirements.txt \
  && pip3 uninstall -y setuptools pip

# -----------------------------------------------------------------------------
# Stage: Final
# -----------------------------------------------------------------------------

# Create the runtime image.

FROM ${BASE_IMAGE} AS runner

ENV REFRESHED_AT=2024-12-06

ARG SENZING_ACCEPT_EULA
ARG SENZING_APT_INSTALL_TOOLS_PACKAGE

ENV SENZING_ACCEPT_EULA=${SENZING_ACCEPT_EULA} \
  SENZING_APT_INSTALL_TOOLS_PACKAGE=${SENZING_APT_INSTALL_TOOLS_PACKAGE}

LABEL Name="senzing/senzingsdk-tools" \
  Maintainer="support@senzing.com" \
  Version="4.0.0"

# Run as "root" for system installation.

USER root

# Eliminate warning messages.

ENV TERM=xterm

# Install Senzing package.

RUN apt-get update -qqq \
  && apt-get -yqqq install ${SENZING_APT_INSTALL_TOOLS_PACKAGE}

HEALTHCHECK CMD apt list --installed | grep senzingsdk-tools

# Install packages via apt.

RUN apt-get update -qqq \
  && apt-get -yqqq install \
  python3-venv \
  && rm -rf /var/lib/apt/lists/*

# Copy python virtual environment from the builder image.

COPY --from=builder /app/venv /app/venv

USER 1001

# Activate virtual environment.

ENV VIRTUAL_ENV=/app/venv
ENV PATH="/app/venv/bin:${PATH}"

# Set environment variables for root.

ENV LANGUAGE=C \
  LC_ALL=C.UTF-8 \
  LD_LIBRARY_PATH=/opt/senzing/er/lib \
  PATH=${PATH}:/opt/senzing/er/python \
  PYTHONPATH=/opt/senzing/er/python:/opt/senzing/er/sdk/python \
  PYTHONUNBUFFERED=1 \
  SENZING_DOCKER_LAUNCHED=true \
  SENZING_SKIP_DATABASE_PERFORMANCE_TEST=true

# Runtime execution.

WORKDIR /
CMD ["/bin/bash"]
