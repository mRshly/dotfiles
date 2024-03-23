#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

### Setup WezTerm

CONFIG_DIR="$HOME/.config/wezterm"
DOTFILES_DIR="$HOME/dotfiles/config/wezterm"

if [ ! -d "$CONFIG_DIR" ]; then
	echo config directory does not exist, creating it
	mkdir -p "${CONFIG_DIR:?}"
fi

echo begin linking wezterm files
echo linking wezterm.lua
ln -sf "${DOTFILES_DIR:?}/wezterm.lua" "$CONFIG_DIR/wezterm.lua"
echo linking format.lua
ln -sf "${DOTFILES_DIR:?}/format.lua" "$CONFIG_DIR/format.lua"
echo linking keybinds.lua
ln -sf "${DOTFILES_DIR:?}/keybinds.lua" "$CONFIG_DIR/keybinds.lua"
echo linking status.lua
ln -sf "${DOTFILES_DIR:?}/status.lua" "$CONFIG_DIR/status.lua"
echo end linking wezterm files
