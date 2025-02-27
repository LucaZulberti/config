#!/usr/bin/env bash

DIR=$(dirname "$0")/..

CONF_DIR="$HOME/.config"
BIN_DIR="$HOME/.local/bin"

mkdir -p $CONF_DIR
mkdir -p $BIN_DIR

ln -srf $DIR/fish $CONF_DIR
ln -srf $DIR/nvim $CONF_DIR
ln -srf $DIR/tmux $CONF_DIR
ln -srf $DIR/tmux-powerline $CONF_DIR
ln -srf $DIR/tmuxp $CONF_DIR

ln -srf $DIR/bin/workenv $BIN_DIR
