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
echo "Positional arguments: ${ARGS[@]}"

# Prepare the `docker run` command
DOCKER_CMD=(docker run -it --rm)
DOCKER_CMD+=(-v "$CONFIG_DIR:/config")
DOCKER_CMD+=(-v "$WORK_DIR:/work")

# Add volume mounts dynamically
for mount in "${VOLUME_MOUNTS[@]}"; do
    DOCKER_CMD+=(-v "$mount")
done

# Add the image name
DOCKER_CMD+=(workenv)

# Add arguments
DOCKER_CMD+=("${ARGS[@]}")

# Execute the command
"${DOCKER_CMD[@]}"
