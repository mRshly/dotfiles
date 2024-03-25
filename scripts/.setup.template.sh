#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

### Setup Package

CONFIG_DIR="$HOME/.config/Package"
DOTFILES_DIR="$HOME/dotfiles/config/Package"

# create symbolic link for config file
echo begin linking Package files
# ln -sf "${DOTFILES_DIR:?}/config" "$CONFIG_DIR/config"
echo end linking Package files
