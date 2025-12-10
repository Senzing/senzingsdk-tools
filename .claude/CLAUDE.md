# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Docker image distribution repository** for `senzing/senzingsdk-tools`. It contains no Python source code—only Docker infrastructure and configuration files. The image provides the Senzing SDK V4 library with Python tools pre-installed, serving as a base image for applications using the Senzingsdk library.

**Important:** This SDK is V4 only and is not compatible with the V3 API (use senzingapi-tools for V3).

## Build Commands

```bash
make docker-build    # Build Docker image with git-derived version tag
make docker-test     # Run validation tests inside Docker container
make clean           # Remove built Docker images
make help            # List all available targets
```

The build uses a multi-stage Dockerfile:

- **builder stage**: Sets up Python virtual environment with dependencies
- **runner stage**: Final image based on `senzing/senzingsdk-runtime`, installs `senzingsdk-tools` APT package

## Testing

Tests run inside the Docker container via `.github/scripts/docker_test_script.sh`:

- Validates required environment variables (LD_LIBRARY_PATH)
- Verifies Senzing installation files exist

Run tests: `make docker-build && make docker-test`

## CI/CD

All CI/CD runs through GitHub Actions:

- **docker-build-container.yaml**: Main build workflow (runs on PRs to main and daily)
- **docker-push-containers-to-dockerhub.yaml**: Pushes to Docker Hub on releases
- **spellcheck.yaml**: Runs cspell on PRs (config in `.vscode/cspell.json`)
- **claude-pr-review.yaml**: Automated Claude code reviews on PRs

## Custom Claude Commands

- `/senzing-code-review` - Performs Senzing-standard code review using external prompt

## Python Dependencies

The image includes these Python packages (see `requirements.txt`):

- prettytable (table formatting)
- psycopg2-binary (PostgreSQL driver)
- pyodbc (ODBC database access)

## Docker Image Details

- **Base image**: `senzing/senzingsdk-runtime:4.1.0`
- **User**: 1001 (non-root)
- **Python venv**: `/app/venv` (added to PATH)
- **Senzing paths**: `/opt/senzing/er/`, `/opt/senzing/data/`
