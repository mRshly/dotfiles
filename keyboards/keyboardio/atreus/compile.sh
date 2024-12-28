#!/usr/bin/env bash

set -e

MY_KEYMAPS=$HOME/dotfiles/keyboards/keyboardio/atreus/Atreus.ino
KALEIDOSCOPE=$HOME/ghq/github.com/keyboardio/Kaleidoscope
TARGET=$KALEIDOSCOPE/examples/Devices/Keyboardio/Atreus/

cp -f "$MY_KEYMAPS" "$TARGET"

pushd "$TARGET"

# if you want to see the verbose output, uncomment the following line
# export VERBOSE=1

make compile

popd
