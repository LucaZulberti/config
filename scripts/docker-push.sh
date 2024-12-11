#!/usr/bin/env bash

tag=$(git rev-parse --abbrev-ref HEAD)

# Push (eventually build) the Docker image for multiple platforms
PLATFORMS="linux/amd64,linux/arm64"
echo "Push (build if necessary) the Docker image for platforms: ${PLATFORMS}"
docker buildx build \
    --push \
    --platform $PLATFORMS \
    -t lucazulberti/workenv:${tag} \
    .

echo "Docker image pushed successfully!"
