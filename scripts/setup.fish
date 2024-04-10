#!/usr/bin/env fish
set -o errexit
set -o nounset
set -o pipefail

set CONFIGPATH "~/.config/fish"
set DOTFILEPATH "~/dotfiles/fish"

mkdir -p $CONFIGPATH
ln -s $DOTFILEPATH/* $CONFIGPATH/

# install fisher
# see: https://github.com/jorgebucaran/fisher
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

# install plugins
set plugins jethrokuan/z patrickf1/fzf.fish decors/fish-ghq oh-my-fish/theme-bobthefish

for plugin in $plugins
    fisher install $plugin
end
