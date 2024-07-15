#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

### Setup poetry

CONFIG_DIR="$HOME/.config/pypoetry"
DOTFILES_DIR="$HOME/dotfiles/config/pypoetry"

# create symbolic link for config file
echo begin linking poetry files
# ln -sf "${DOTFILES_DIR:?}/config" "$CONFIG_DIR/config"
echo end linking poetry files

# Generate completions
poetry completions fish >~/.config/fish/completions/poetry.fish

# Set my configuration
poetry config virtualenvs.in-project true
poetry config virtualenvs.prompt "{project_name}"
