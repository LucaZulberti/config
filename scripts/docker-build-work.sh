#!/usr/bin/env bash

docker build \
    --build-arg HOST_UID=$(id -u) \
    --build-arg HOST_GID=$(id -g) \
    -t workenv \
    -f Dockerfile.work \
    .
