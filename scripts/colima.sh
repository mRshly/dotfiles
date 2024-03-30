#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

### Setup Colima

CONFIG_DIR="$HOME/.config/colima"
DOTFILES_DIR="$HOME/dotfiles/config/colima"
CLI_PLUGINS_DIR="$HOME/.config/.docker/cli-plugins"

# if [ ! -d "${CONFIG_DIR}" ]; then
# 	echo "Config directory does not exist. Exiting..."
# 	exit 1
# fi

# create symbolic link for config file
# echo begin linking Colima files
# ln -sf "${DOTFILES_DIR:?}/config" "$CONFIG_DIR/config"
# echo end linking Colima files

# Source of this sequence is bellow
# https://github.com/abiosoft/colima/discussions/273#discussioncomment-4959736
echo begin Buildx install in Colima
if ! command -v docker-buildx &>/dev/null; then
	echo "docker-buildx not found. Installing..."
	brew install docker-buildx
fi
echo "make directory for buildx"
mkdir -p "$CLI_PLUGINS_DIR"
echo "linking \`buildx\` to docker cli plugins"
ln -sfn "$(which docker-buildx)" "$CLI_PLUGINS_DIR"/docker-buildx
docker buildx install
echo end Buildx install in Colima
