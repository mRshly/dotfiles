#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

CONFIGPATH=$HOME/.config/lazygit
DOTFILEPATH=$HOME/dotfiles/config/lazygit

if [ ! -d "$CONFIGPATH" ]; then
  echo config directory does not exist, creating it
  mkdir -p "${CONFIGPATH:?}"
fi

echo BEGIN linking lazygit files
ln -sf $DOTFILEPATH/config.yml $CONFIGPATH/config.yml
echo END linking lazygit files
