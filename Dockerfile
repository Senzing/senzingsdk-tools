ARG BASE_IMAGE=senzing/senzingsdk-runtime:4.1.0@sha256:e57d751dc0148bb8eeafedb7accf988413f50b54a7e46f25dfe4559d240063e5

# Create the runtime image.

ARG SENZING_APT_INSTALL_TOOLS_PACKAGE="senzingsdk-tools"

# -----------------------------------------------------------------------------
# Stage: builder
# -----------------------------------------------------------------------------

FROM ${BASE_IMAGE} AS builder

ENV REFRESHED_AT=2025-11-11

# Run as "root" for system installation.

USER root

# Install packages via apt-get.

RUN apt-get update \
 && apt-get -y --no-install-recommends install \
      python3 \
      python3-dev \
      python3-pip \
      python3-venv \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* \
 && rm -rf /var/tmp/* \
 && rm -rf ~/.cache

# Create and activate virtual environment.

RUN python3 -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

# Install packages via PIP.

COPY requirements.txt .
RUN pip3 install --no-cache-dir --upgrade pip \
 && pip3 install --no-cache-dir -r requirements.txt \
 && rm requirements.txt \
 && pip3 uninstall -y setuptools wheel

# -----------------------------------------------------------------------------
# Stage: Final
# -----------------------------------------------------------------------------

# Create the runtime image.

FROM ${BASE_IMAGE} AS runner

ENV REFRESHED_AT=2025-11-11

ARG SENZING_APT_INSTALL_TOOLS_PACKAGE

ENV SENZING_APT_INSTALL_TOOLS_PACKAGE=${SENZING_APT_INSTALL_TOOLS_PACKAGE}

LABEL Name="senzing/senzingsdk-tools" \
      Maintainer="support@senzing.com" \
      Version="4.1.0"

# Run as "root" for system installation.

USER root

# Eliminate warning messages.

ENV TERM=xterm

# Install Senzing package.

RUN apt-get update \
 && apt-get -y --no-install-recommends install \
      ${SENZING_APT_INSTALL_TOOLS_PACKAGE}\
      python3-venv \
      unixodbc \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* \
 && rm -rf /var/tmp/* \
 && rm -rf /var/cache/apt/*

HEALTHCHECK CMD apt list --installed | grep senzingsdk-tools

# Copy python virtual environment from the builder image.

COPY --from=builder /app/venv /app/venv
RUN chmod -R a+rwX /app/venv

USER 1001

# Activate virtual environment.

ENV VIRTUAL_ENV=/app/venv
ENV PATH="/app/venv/bin:${PATH}"

# Set environment variables for root.

ENV LANGUAGE=C \
    LC_ALL=C.UTF-8 \
    LD_LIBRARY_PATH=/opt/senzing/er/lib \
    PATH=${PATH}:/opt/senzing/er/bin \
    PYTHONPATH=/opt/senzing/er/python:/opt/senzing/er/sdk/python \
    PYTHONUNBUFFERED=1 \
    SENZING_DOCKER_LAUNCHED=true \
    SENZING_SKIP_DATABASE_PERFORMANCE_TEST=true

# Runtime execution.

WORKDIR /
CMD ["/bin/bash"]
