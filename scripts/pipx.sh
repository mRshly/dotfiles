#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

if ! command -v pip &>/dev/null; then
	echo "pip is not installed. Please install it."
	exit 1
fi

# TODO: test argcomplete is installed if yes I want to do not pip install argcomplete
pip install argcomplete

register-python-argcomplete --shell fish pipx >~/.config/fish/completions/pipx.fish
