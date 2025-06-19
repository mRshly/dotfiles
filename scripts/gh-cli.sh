#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

APPNAME=gh-cli
CONFIGPATH=$HOME/.config/gh
DOTFILEPATH=$HOME/dotfiles/config/gh

if [ ! -d "$CONFIGPATH" ]; then
  echo config directory does not exist, creating it
  mkdir -p "${CONFIGPATH:?}"
fi

echo BEGIN linking $APPNAME files
ln -sf $DOTFILEPATH/config.yml $CONFIGPATH/config.yml
ln -sf $DOTFILEPATH/hosts.yml $CONFIGPATH/hosts.yml
echo END linking $APPNAME files
