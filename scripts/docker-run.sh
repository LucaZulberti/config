#!/usr/bin/env bash

: ${CONFIG_DIR:=$HOME/.config}

# Ask the user if they want to continue
echo -e "You will mount:\n\t - ${CONFIG_DIR}:/config\n\t - $(pwd):/work\n\nDo you want to continue? (y/n)"
read -r reply

# Check the user's reply
if [[ "$reply" =~ ^[Yy]$ ]]; then
    docker run -it --rm \
        -v workenv_local:/home/ubuntu/.local \
        -v $CONFIG_DIR:/config \
        -v $(pwd):/work \
        workenv
else
    exit 1
fi
