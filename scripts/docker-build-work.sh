#!/usr/bin/env bash

# Detect the operating system
if [[ "$(uname)" == "Darwin" ]]; then
    # macOS detected
    echo "Building on macOS"
    docker build \
        -t workenv \
        -f Dockerfile.work \
        .
else
    # Non-macOS (e.g., Linux)
    echo "Building on Linux - using host UID=$(id -u) and GID=$(id -g)"
    docker build \
        --build-arg HOST_UID=$(id -u) \
        --build-arg HOST_GID=$(id -g) \
        --build-arg HOST_USER=$(id -u -n) \
        --build-arg HOST_GROUP=$(id -g -n) \
        -t workenv:$USER \
        -f Dockerfile.work \
        .
fi

