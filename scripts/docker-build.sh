#!/usr/bin/env bash

tag=$(git rev-parse --abbrev-ref HEAD)

# Docker builder name for multi-arch builds
BUILDER_NAME="multi-arch-builder"

# Check if the builder exists
EXISTING_BUILDER=$(docker buildx ls | grep "$BUILDER_NAME" 2> /dev/null)

# If the builder does not exist, create a new one
if [ -z "$EXISTING_BUILDER" ]; then
    echo "Creating the builder..."
    docker buildx create --name "$BUILDER_NAME" --use
else
    echo "Using existing builder: $BUILDER_NAME"
fi

# Build the Docker image for multiple platforms
PLATFORMS="linux/amd64,linux/arm64"
echo "Building the Docker image for platforms: ${PLATFORMS}"
docker buildx build \
    --platform $PLATFORMS \
    -t lucazulberti/workenv:${tag} \
    .

echo "Docker image built successfully!"
