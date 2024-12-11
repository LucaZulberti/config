#!/usr/bin/env bash

# Docker builder name for multi-arch builds
builder="multi-arch-builder"

# If the builder does not exist, create a new one
if [ -z "$(docker buildx ls | grep "$builder" 2> /dev/null)" ]; then
    echo "Creating the builder..."
    docker buildx create --name "$builder" --use
else
    echo "Using existing builder: $builder"
fi

# Build the Docker image for multiple platforms
platforms="linux/amd64,linux/arm64"
name=lucazulberti/workenv

# Build arguments
docker_build_args=(--platform $platforms)

# If branch is main, tag the image as latest
branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$branch" == "main" ]; then
    docker_build_args+=(-t ${name}:latest)
else
    # Otherwise, tag the image with the branch name
    docker_build_args+=(-t ${name}:${branch})
fi

echo "${docker_build_args[@]}"

# Build the Docker image, passing additional arguments
echo "Building the Docker image for platforms: ${platforms}"
docker buildx build "${docker_build_args[@]}" "$@" .
echo "Docker image built successfully!"
