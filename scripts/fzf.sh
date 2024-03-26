#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

### Setup fzf

# CONFIG_DIR="$HOME/.config/Package"
# DOTFILES_DIR="$HOME/dotfiles/config/Package"
BIN_DIR="$HOME/dotfiles/bin"
DEST_BIN_DIR="$HOME"/.local/bin

# if [ ! -d "${CONFIG_DIR}" ]; then
# 	echo "Config directory does not exist. Exiting..."
# 	exit 1
# fi

# create symbolic link for config file
echo begin linking fzf files
ln -sf "${BIN_DIR:?}/rfv" "$DEST_BIN_DIR/rfv"
echo end linking fzf files
