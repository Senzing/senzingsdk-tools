#!/usr/bin/env bash

# Check ENV for LD_LIBRARY_PATH
if [[ -z "${LD_LIBRARY_PATH}" ]]; then
  echo "[ERROR] Environment variable LD_LIBRARY_PATH is not set"
  exit 1
fi

# Verify that some Senzing files have been installed
# /opt/senzing/er/szBuildVersion.json  (log contents)
FILE=/opt/senzing/er/szBuildVersion.json
if test -f "$FILE"; then
    echo "[INFO] $FILE exists."
else
    echo "[ERROR] $FILE does not exist."
    exit 1
fi

# /opt/senzing/data/szBuildVersion.json
FILE=/opt/senzing/data/szBuildVersion.json
if test -f "$FILE"; then
    echo "[INFO] $FILE exists."
else
    echo "[ERROR] $FILE does not exist."
    exit 1
fi
