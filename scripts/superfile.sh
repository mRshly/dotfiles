#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

### Setup superfile

CONFIG_DIR="$HOME/.config/superfile"
DOTFILES_DIR="$HOME/dotfiles/config/superfile"

if [ ! -d "${CONFIG_DIR}" ]; then
  echo "Config directory does not exist. Exiting..."
  exit 1
fi

# create symbolic link for config file
echo begin linking superfile files
ln -sf "${DOTFILES_DIR:?}/config.toml" "$CONFIG_DIR/config.toml"
ln -sf "${DOTFILES_DIR:?}/hotkeys.toml" "$CONFIG_DIR/hotkeys.toml"
echo end linking superfile files
