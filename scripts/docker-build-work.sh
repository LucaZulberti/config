#!/usr/bin/env bash

# Detect the operating system
if [[ "$(uname)" == "Darwin" ]]; then
    # macOS detected
    echo "Building on macOS - host UID and GID are not needed."
    docker build \
        -t workenv \
        -f Dockerfile.work \
        .
else
    # Non-macOS (e.g., Linux)
    echo "Building on Linux - using host UID=${UID} and GID=${GID}."
    docker build \
        --build-arg HOST_UID=$(id -u) \
        --build-arg HOST_GID=$(id -g) \
        -t workenv \
        -f Dockerfile.work \
        .
fi

