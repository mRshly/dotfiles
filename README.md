# Dotfiles

## How to manage my dotfiles

Managed by chezmoi, Nix flakes, nix-darwin, Home Manager, Homebrew, and mise.

## First step

Clone this repository, then follow the [Nix workflow](#nix-workflow) below to install packages via nix-darwin/Home Manager. 

## Supported Platforms

- [x] MacOS
- [ ] Linux
- [ ] Windows

## Apply config

```bash
chezmoi apply
```

## RunCat Neo: Codex usage

Apply the Codex hook and converter with `chezmoi apply`. Restart Codex, open
`/hooks`, and trust the new user-level `Stop` hook when prompted.

After the first completed Codex turn creates `~/.codex/runcat-usage.json`, open
RunCat Neo settings and add that file as a Custom Metrics source named `Codex`.
This file-selection step grants RunCat Neo the required macOS sandbox access.

## Nix workflow

First-time nix-darwin install: follow [docs/migration/first-switch-checklist.md](docs/migration/first-switch-checklist.md) (one-time backups and ordering constraints), then:

```bash
nix flake check
nix build .#darwinConfigurations.ShadowComet.system
sudo nix run github:nix-darwin/nix-darwin#darwin-rebuild -- switch --flake .#ShadowComet
```

Daily build without activating:

```bash
nix flake check
darwin-rebuild build --flake .#ShadowComet
```

Activate after reviewing the build:

```bash
darwin-rebuild switch --flake .#ShadowComet
```


### Fish plugins (not yet in Nix)

Fish itself and its config are managed by Home Manager (`nix/home/programs/fish.nix`), but the [fisher](https://github.com/jorgebucaran/fisher) plugin manager and its plugins are not yet migrated and must still be installed manually:

```bash
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
fisher install jethrokuan/z patrickf1/fzf.fish decors/fish-ghq edc/bass
```

## Keyboardio Atreus

My [Keyboardio Atreus](https://shop.keyboard.io/products/keyboardio-atreus) firmware is [kaleidoscope](https://github.com/keyboardio/Kaleidoscope).

Clone repository by [ghq](https://github.com/x-motemen/ghq) like,

```bash
ghq get git@github.com:keyboardio/Kaleidoscope.git`
```

Then, move to `keyboards/keyboardio/atreus` and flash by `./compile.sh && flash.sh` .
