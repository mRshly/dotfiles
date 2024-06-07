#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

### Setup hatch

CONFIG_DIR="$HOME/.config/hatch"
DOTFILES_DIR="$HOME/dotfiles/config/hatch"

if [ ! -d "${CONFIG_DIR}" ]; then
	echo "Config directory does not exist. Exiting..."
	exit 1
fi

# create symbolic link for config file
echo begin linking hatch files
ln -sf "${DOTFILES_DIR:?}/config.toml" "$CONFIG_DIR/config.toml"
echo end linking hatch files
