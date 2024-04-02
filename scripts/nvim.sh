#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

### setup neovim

CONFIGPATH=~/.config/nvim
DOTFILEPATH=~/dotfiles/config/nvim

if [ ! -d "$CONFIG_DIR" ]; then
	echo config directory does not exist, creating it
	mkdir -p "${CONFIG_DIR:?}"
fi

echo begin linking neovim files
ln -sf "${DOTFILEPATH:?}"/init.lua "${CONFIGPATH:?}"/
ln -sf "${DOTFILEPATH:?}"/*.json "${CONFIGPATH:?}"/
ln -sf "${DOTFILEPATH:?}"/stylua.toml "${CONFIGPATH:?}"/
ln -sf "${DOTFILEPATH:?}"/README.md "${CONFIGPATH:?}"/
ln -sf "${DOTFILEPATH:?}"/LICENSE "${CONFIGPATH:?}"/
ln -sf "${DOTFILEPATH:?}"/.gitignore "${CONFIGPATH:?}"/
ln -sf "${DOTFILEPATH:?}"/lua "${CONFIGPATH:?}"/
echo end linking neovim files

## set gitconfig

# core
git config --global core.editor nvim

# merge
git config --global merge.tool nvimdiff
git config --global mergetool.prompt false
git config --global mergetool.keepBackup false
git config --global mergetool."nvimdiff".layout "LOCAL,BASE,REMOTE /MERGED"
