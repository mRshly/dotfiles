#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

### Setup git-delta

CONFIG="$HOME/.gitconfig"

# Add global gitconfig
echo begin add global gitconfig
git config --global core.pager "delta"
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true
git config --global delta.line-numbers true
git config --global merge.conflictstyle "diff3"
git config --global diff.colorMoved "default"

# color theme
# tokyonight_night: https://github.com/folke/tokyonight.nvim/blob/main/extras/delta/tokyonight_night.gitconfig
git config --global delta.minus-style "syntax '#37222c'"
git config --global delta.minus-non-emph-style "syntax '#37222c'"
git config --global delta.minus-emph-style "syntax '#713137'"
git config --global delta.minus-empty-line-marker-style "syntax '#37222c'"
git config --global delta.line-numbers-minus-style "#b2555b"
git config --global delta.plus-style "syntax '#20303b'"
git config --global delta.plus-non-emph-style "syntax '#20303b'"
git config --global delta.plus-emph-style "syntax '#2c5a66'"
git config --global delta.plus-empty-line-marker-style "syntax '#20303b'"
git config --global delta.line-numbers-plus-style "#266d6a"
git config --global delta.line-numbers-zero-style "#3b4261"

echo end add global gitconfig

bat "${CONFIG:?}"
