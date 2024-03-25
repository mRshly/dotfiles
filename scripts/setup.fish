#!/usr/bin/env fish
set -o errexit
set -o nounset
set -o pipefail

set CONFIGPATH "~/.config/fish"
set DOTFILEPATH "~/dotfiles/fish"

ln -s $DOTFILEPATH/* $CONFIGPATH/

# install fisher
# see: https://github.com/jorgebucaran/fisher
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

# install plugins
set plugins jethrokuan/z patrickf1/fzf.fish decors/fish-ghq

for plugin in $plugins
  fisher install $plugin
end

# install oh-my-fish
# see: https://github.com/oh-my-fish/oh-my-fish
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish

# install bobthefish
# see: https://github.com/oh-my-fish/theme-bobthefish
omf install bobthefish
