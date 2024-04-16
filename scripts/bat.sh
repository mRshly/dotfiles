#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

### Setup bat

CONFIG_DIR="$HOME/.config/bat"
DOTFILES_DIR="$HOME/dotfiles/config/bat"
THEME_DIR="$HOME/dotfiles/themes"

echo "Begin setup bat"

if [ ! -d "${CONFIG_DIR}" ]; then
	echo "Config directory does not exist. Creating..."
	mkdir -p "${CONFIG_DIR}"
fi

# create symbolic link for config file
echo begin linking bat files
ln -sf "${DOTFILES_DIR:?}/config" "$CONFIG_DIR/config"
# create symbolic link for themes
mkdir -p "${CONFIG_DIR:?}/themes/tokyonight"
ln -sf "${THEME_DIR:?}/tokyonight.nvim/extras/sublime/tokyonight_day.tmTheme" "${CONFIG_DIR:?}/themes/tokyonight/"
ln -sf "${THEME_DIR:?}/tokyonight.nvim/extras/sublime/tokyonight_moon.tmTheme" "${CONFIG_DIR:?}/themes/tokyonight/"
ln -sf "${THEME_DIR:?}/tokyonight.nvim/extras/sublime/tokyonight_night.tmTheme" "${CONFIG_DIR:?}/themes/tokyonight/"
ln -sf "${THEME_DIR:?}/tokyonight.nvim/extras/sublime/tokyonight_storm.tmTheme" "${CONFIG_DIR:?}/themes/tokyonight/"

echo end linking bat files

bat cache --build

echo "End setup bat"
