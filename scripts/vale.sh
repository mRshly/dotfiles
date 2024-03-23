#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

### Post install Vale setup
# This script is used to setup Vale after it has been installed.

CONFIG_DIR="${HOME}/.config/vale"

if [ ! -d "${CONFIG_DIR}" ]; then
	echo "Config directory does not exist. Exiting..."
	exit 1
fi

echo config directory is "${CONFIG_DIR:?}"

cd "${CONFIG_DIR:?}"
vale sync
