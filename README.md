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

Two Apple Silicon hosts share the packages and Home Manager modules under `nix/darwin` and `nix/home`. Machine-specific settings stay under `nix/hosts`.

- `ShadowComet`: M1 MacBook Air (`shadowcomet`)
- `ShadowMercury`: M4 Mac mini (`shadowmercury`)

First-time nix-darwin install on ShadowMercury:

```bash
nix flake check
nix build .#darwinConfigurations.ShadowMercury.system
sudo nix run github:nix-darwin/nix-darwin#darwin-rebuild -- switch --flake .#ShadowMercury
```

Daily build without activating:

```bash
nix flake check
darwin-rebuild build --flake ".#$(scutil --get LocalHostName)"
```

Activate after reviewing the build. System activation must run as root, so
`sudo` is required for `switch`:

```bash
sudo darwin-rebuild switch --flake ".#$(scutil --get LocalHostName)"
```


### Fish plugins (not yet in Nix)

Fish itself and its config are managed by Home Manager (`nix/home/programs/fish.nix`), but the [fisher](https://github.com/jorgebucaran/fisher) plugin manager and its plugins are not yet migrated and must still be installed manually:

```bash
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
fisher install jethrokuan/z patrickf1/fzf.fish edc/bass
```

## Homebrew

Homebrew is managed declaratively by the nix-darwin `homebrew` module in
`nix/darwin/homebrew.nix`, with `onActivation.cleanup = "uninstall"`.

Anything not declared there is uninstalled on every `darwin-rebuild switch`.
This covers formulae, casks, taps, and Mac App Store apps. A manual
`brew install` only survives until the next switch, so add it to
`nix/darwin/homebrew.nix` to keep it.

Packages live in Homebrew only when they cannot move to nixpkgs. The reason for
each one is recorded as a comment above the `brews` list.

## Keyboardio Atreus

Keymaps and flashing scripts for my
[Keyboardio Atreus](https://shop.keyboard.io/products/keyboardio-atreus) live in
a separate repository: [mRshly/atreus-config](https://github.com/mRshly/atreus-config).

`nix/home/programs/fish.nix` exports `KALEIDOSCOPE_DIR`, which those scripts use
to locate [Kaleidoscope](https://github.com/keyboardio/Kaleidoscope).
