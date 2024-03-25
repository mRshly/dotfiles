#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

### Post install Vale setup
# This script is used to setup Vale after it has been installed.

CONFIG_DIR="${HOME}/.config/vale"
DOTFILE_DIR="${HOME}/dotfiles/config/vale"

if [ ! -d "${CONFIG_DIR}" ]; then
	echo "Config directory does not exist. Exiting..."
	exit 1
fi

echo config directory is "${CONFIG_DIR:?}"

# Link Vale configuration files
echo Begin linking Vale configuration files
ln -s "${DOTFILE_DIR}/.vale.ini" "${CONFIG_DIR:?}/.vale.ini"
ln -s "${DOTFILE_DIR}/styles" "${CONFIG_DIR:?}/styles"
echo End linking Vale configuration files

# Sync Vale styles
echo Begin linkng Vale styles
cd "${CONFIG_DIR:?}"
vale sync
