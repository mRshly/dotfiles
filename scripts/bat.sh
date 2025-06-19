#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

APPNAME=bat
CONFIGPATH=$HOME/.config/bat
DOTFILEPATH=$HOME/dotfiles/config/bat

if [ ! -d "$CONFIGPATH" ]; then
  echo config directory does not exist, creating it
  mkdir -p "${CONFIGPATH:?}"
fi

echo BEGIN linking $APPNAME files
ln -sf $DOTFILEPATH/config $CONFIGPATH/config
echo END linking $APPNAME files
