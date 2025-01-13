#!/usr/bin/env bash

# Default values for arguments
CONFIG_DIR="$HOME/.config"
WORK_DIR="$(pwd)"
MOUNTS=()
ARGS=()

# Print usage instructions
usage() {
    echo "Usage: $0 [-c CONFIG_DIR] [-w WORK_DIR] [--] <...args>"
    echo "   -c, --config CONFIG_DIR    Specify the config directory. Default: $CONFIG_DIR"
    echo "   -w, --work WORK_DIR        Specify the work directory. Default: $WORK_DIR"
    echo "   -v, --volume SRC:DST       Add additional volume mounts (can be used multiple times)."
    echo "   <...args> are passed directly to the invoked command."
    echo "   Use -- to separate options from <...args> if needed."
    exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -c|--config)
            CONFIG_DIR="$2"
            shift 2
            ;;
        -w|--work)

            WORK_DIR="$2"
            shift 2
            ;;
        -e|--environment)
            if [[ -z "$2" ]]; then
                echo "Error: --environment requires a value (e.g., VAR=VALUE)."
                exit 1
            fi
            ENV_VARIABLES+=("$2")
            shift 2
            ;;
        -v|--volume)
            if [[ -z "$2" ]]; then
                echo "Error: --volume requires a value (e.g., /source:/destination)."
                exit 1
            fi
            VOLUME_MOUNTS+=("$2")
            shift 2
            ;;
        --)
            shift
            ARGS+=("$@")
            ;;
        -h|--help)
            usage
            ;;
        -*)
            echo "Unknown option: $1"
            usage
            ;;
            
        *)
            ARGS+=("$1")
            shift
            ;;
    esac
done

# Print the parsed values
echo "Config directory: $CONFIG_DIR"
echo "Work directory: $WORK_DIR"
echo "Environment variables:"
for variable in "${ENV_VARIABLES[@]}"; do
    echo "- $variable"
done
echo "Volumes:"
for mount in "${VOLUME_MOUNTS[@]}"; do
    echo "- $mount"
done
echo "Positional arguments: ${ARGS[@]}"
echo ""

# Docker
# ------

CONFIG_NAME=$(basename "$CONFIG_DIR")
WORK_NAME=$(basename "$WORK_DIR")
IMAGE_NAME="workenv"
CONTAINER_NAME="${IMAGE_NAME}-${CONFIG_NAME}-${WORK_NAME}"

# Prepare the docker command
DOCKER_ARGS=(-v "$CONFIG_DIR:/config")
DOCKER_ARGS+=(-v "$WORK_DIR:/work")

# Add environemnt variables dynamically
for variable in "${ENV_VARIABLES[@]}"; do
    DOCKER_ARGS+=(-e "$variable")
done

# Add volume mounts dynamically
for mount in "${VOLUME_MOUNTS[@]}"; do
    DOCKER_ARGS+=(-v "$mount")
done

# Add the image name
DOCKER_ARGS+=($IMAGE_NAME)

# Add additional arguments
DOCKER_ARGS+=("${ARGS[@]}")

# Check if the container is already running
if docker inspect -f '{{.State.Running}}' "${CONTAINER_NAME}" 2>/dev/null | grep -q "true"; then
    echo "Container '${CONTAINER_NAME}' is running. Attaching..."
    echo ""
    docker attach "${CONTAINER_NAME}"
elif docker inspect "${CONTAINER_NAME}" >/dev/null 2>&1; then
    echo "Container '${CONTAINER_NAME}'is not running. Starting..."
    docker start "${CONTAINER_NAME}" > /dev/null
    echo "Container '${CONTAINER_NAME}' started. Attaching..."
    echo ""
    docker attach "${CONTAINER_NAME}"
else
    echo "Container '${CONTAINER_NAME}' does not exist. Creating and starting..."
    echo ""
    docker run -it \
        --name "${CONTAINER_NAME}" \
        --hostname "workenv" \
        "${DOCKER_ARGS[@]}"
fi
