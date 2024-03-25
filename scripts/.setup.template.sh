#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

### Setup Package

CONFIG_DIR="$HOME/.config/Package"
DOTFILES_DIR="$HOME/dotfiles/config/Package"

if [ ! -d "${CONFIG_DIR}" ]; then
	echo "Config directory does not exist. Exiting..."
	exit 1
fi

# create symbolic link for config file
echo begin linking Package files
# ln -sf "${DOTFILES_DIR:?}/config" "$CONFIG_DIR/config"
echo end linking Package files
