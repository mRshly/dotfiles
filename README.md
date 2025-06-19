# Dotfiles

## How to manage my dotfiles

Totally managed by Homebrew.

Programming languages and environment are managed by mise.

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
