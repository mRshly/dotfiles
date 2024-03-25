#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

### setup neovim

CONFIGPATH=~/.config/nvim
DOTFILEPATH=~/dotfiles/config/nvim

echo begin linking neovim files
ln -sf "${DOTFILEPATH:?}"/init.lua "${CONFIGPATH:?}"/
ln -sf "${DOTFILEPATH:?}"/*.json "${CONFIGPATH:?}"/
ln -sf "${DOTFILEPATH:?}"/stylua.toml "${CONFIGPATH:?}"/
ln -sf "${DOTFILEPATH:?}"/README.md "${CONFIGPATH:?}"/
ln -sf "${DOTFILEPATH:?}"/LICENSE "${CONFIGPATH:?}"/
ln -sf "${DOTFILEPATH:?}"/.gitignore "${CONFIGPATH:?}"/
ln -sf "${DOTFILEPATH:?}"/lua "${CONFIGPATH:?}"/
echo end linking neovim files
