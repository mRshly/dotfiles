#!/usr/bin/env bash

set -e

nix build ./#darwinConfigurations.shadowcomet.system
./result/sw/bin/darwin-rebuild switch --flake .

scripts/wezterm.sh
scripts/nvim.sh
scripts/fzf.sh
