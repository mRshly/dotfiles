#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

### Setup lazygit

CONFIG_DIR="$HOME/.config/lazygit"
DOTFILES_DIR="$HOME/dotfiles/config/lazygit"

if [ ! -d "${CONFIG_DIR}" ]; then
	echo "Config directory does not exist. Exiting..."
	exit 1
fi

# create symbolic link for config file
echo begin linking lazygit files
ln -sf "${DOTFILES_DIR:?}/config.yml" "$CONFIG_DIR/config.yml"
echo end linking lazygit files
