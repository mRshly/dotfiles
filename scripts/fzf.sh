#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

### Setup rfv

BIN_DIR="$HOME/dotfiles/bin"
DEST_BIN_DIR="$HOME"/.local/bin

if [ ! -d "{$DEST_BIN_DIR}" ]; then
  echo "Creating directory for bin files"
  mkdir -p "$DEST_BIN_DIR"
fi

# create symbolic link for config file
echo begin linking fzf files
ln -sf "${BIN_DIR:?}/rfv" "$DEST_BIN_DIR/rfv"
echo end linking fzf files
