#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

### Setup tre-command

CONFIG_DIR="$HOME/.config/fish/functions"
DOTFILES_DIR="$HOME/dotfiles/config/tre-command"

if [ ! -d "${CONFIG_DIR}" ]; then
	echo "Config directory does not exist. Exiting..."
	exit 1
fi

# create symbolic link for config file
echo begin linking tre-command files
ln -sf "${DOTFILES_DIR:?}/config/fish/functions/tre.fish" "$CONFIG_DIR/tre.fish"
echo end linking tre-command files
