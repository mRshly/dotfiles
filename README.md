# Dotfiles

## How to manage my dotfiles

I use [DeterminateSystem/nix-installer](https://github.com/DeterminateSystems/nix-installer) to install Nix as my package manager, and [home-manager](https://github.com/nix-community/home-manager) to manage the packages I use.

Some GUI apps are not available in nixpkgs, so I install them using [Homebrew](https://brew.sh/).

In addition, my macOS configuration is managed by [nix-darwin](https://github.com/LnL7/nix-darwin/tree/master).

## Apply my configurations

Exec `./apply.sh`.

## Supported Platforms

- [x] MacOS
- [ ] Linux
- [ ] Windows

## 🤖 Copilot in `Neovim`

First, setup copilot in `neovim` with `:Copilot auth` command.

## Create symbolic link

```bash
ln -s ~/dotfiles/config/<package> ~/.config/<package>
```

## Keyboardio Atreus

My [Keyboardio Atreus](https://shop.keyboard.io/products/keyboardio-atreus) firmware is [kaleidoscope](https://github.com/keyboardio/Kaleidoscope).

Clone repository by [ghq](https://github.com/x-motemen/ghq) like,

```bash
ghq get git@github.com:keyboardio/Kaleidoscope.git`
```

then, move to `keyboards/keyboardio/atreus` and flash by `./compile.sh && flash.sh` .
