#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

### Setup github-cli
if ! git config --global --get user.name; then
	echo "config: user.name does not set. Set config with \`git config --global user.name <username>\`"
	exit 1
elif ! git config --global --get user.email; then
	echo "config: user.email does not set. Set config with \`git config --global user.email <email>\`"
	exit 1
fi

# authentication for github
# You shoud do setting ssh for github before this setup
gh auth login

gh extension install github/gh-copilot
