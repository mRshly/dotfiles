#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

### Setup git-delta

CONFIG="$HOME/.gitconfig"

# Add global gitconfig
echo begin add global gitconfig
git config --global core.pager "delta"
git config --global interactive.diffFilter "delta"
git config --global delta.navigate true
git config --global merge.conflictstyle "diff3"
git config --global diff.colorMoved "default"
echo end add global gitconfig

bat "${CONFIG:?}"
