#!/usr/bin/env bash

set -euo pipefail

# Root folder is where this script resides
DIR=$(dirname "$0")

# User folders
CONF_DIR="$HOME/.config"
BIN_DIR="$HOME/.local/bin"

# Replace symlink function
replace_symlink() {
    local source=$1
    local destination=$2

    # Check if destination is not a symlink
    if [[ -L "$destination" ]]; then
        :
    elif [[ -e "$destination" ]]; then
        printf 'Warning: "%s" exists and is not a symlink.\n' "$destination"
        read -r -p "Remove it? [y/N] " reply
        case "$reply" in
            y|Y|yes|YES)
                rm -rf -- "$destination"
                ;;
            *)
                printf 'Skipped: "%s"\n' "$destination"
                return 0
                ;;
        esac
    fi

    ln -sf --relative -- "$source" "$destination"
}

mkdir -p -- "$CONF_DIR" "$BIN_DIR"

# Create symlinks for all tools
replace_symlink "$DIR/fish"           "$CONF_DIR/fish"
replace_symlink "$DIR/tmux"           "$CONF_DIR/tmux"
replace_symlink "$DIR/tmux-powerline" "$CONF_DIR/tmux-powerline"
replace_symlink "$DIR/tmuxp"          "$CONF_DIR/tmuxp"
replace_symlink "$DIR/nvim"           "$CONF_DIR/nvim"
replace_symlink "$DIR/bin/workenv"    "$BIN_DIR/workenv"

echo "WorkEnv setup completed successfully!"
echo ""
echo "Add this to you bash aliases (~/.bash_aliases) and customize with your shortcuts:"
cat $DIR/scripts/template.bash_aliases
