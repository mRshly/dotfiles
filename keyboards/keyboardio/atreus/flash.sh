#!/usr/bin/env bash

set -e

KALEIDOSCOPE=$HOME/ghq/github.com/keyboardio/Kaleidoscope
TARGET=$KALEIDOSCOPE/examples/Devices/Keyboardio/Atreus/

pushd "$TARGET"

make flash

popd
