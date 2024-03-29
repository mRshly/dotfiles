#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

### Setup mise

CONFIG_DIR="$HOME/.config/mise"
DOTFILES_DIR="$HOME/dotfiles/config/mise"

if [ ! -d "$CONFIG_DIR" ]; then
	echo config directory does not exist, creating it
	mkdir -p "${CONFIG_DIR:?}"
fi

# create symbolic link for config file
echo begin linking mise files
ln -sf "${DOTFILES_DIR:?}/config.toml" "$CONFIG_DIR/config.toml"
echo end linking mise files

# add completion
mise completion fish >~/.config/fish/completions/mise.fish

# install plugins
mise i
