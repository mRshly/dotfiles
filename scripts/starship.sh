#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

APPNAME=starship
CONFIGPATH=$HOME/.config/
DOTFILEPATH=$HOME/dotfiles/config/starship

if [ ! -d "$CONFIGPATH" ]; then
  echo config directory does not exist, creating it
  mkdir -p "${CONFIGPATH:?}"
fi

echo BEGIN linking $APPNAME files
ln -sf $DOTFILEPATH/starship.toml $CONFIGPATH/starship.toml
echo END linking $APPNAME files
