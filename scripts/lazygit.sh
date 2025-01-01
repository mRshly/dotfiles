#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

### Setup lazygit

CONFIG_DIR="$HOME/.config/lazygit"
DOTFILES_DIR="$HOME/dotfiles/config/lazygit"

mkdir -p $CONFIG_DIR
# create symbolic link for config file
echo begin linking lazygit files
ln -sf "${DOTFILES_DIR:?}/config.yml" "$CONFIG_DIR/config.yml"
echo end linking lazygit files
