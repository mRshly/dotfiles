#!/usr/bin/env fish

set APPNAME fish
set CONFIGPATH ~/.config/fish
set DOTFILEPATH ~/dotfiles/config/fish

if not test -d "$CONFIGPATH"
    echo "config directory does not exist, creating it"
    mkdir -p "$CONFIGPATH"
end

echo "BEGIN linking $APPNAME files"
ln -sf "$DOTFILEPATH/config.fish" "$CONFIGPATH/config.fish"
ln -sf "$DOTFILEPATH/abbr.fish" "$CONFIGPATH/abbr.fish"
echo "END linking $APPNAME files"

# install/update fisher
if type -q fisher
    echo "Fisher is already installed. Updating..."
    # fisher 本体とインストール済みの全プラグインを更新
    fisher update
else
    echo "Fisher not found. Installing..."
    # fisher を初回インストール
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
end

# install plugins
fisher install jethrokuan/z patrickf1/fzf.fish decors/fish-ghq edc/bass
