# Dotfiles

## How to manage my dotfiles

Managed by brew, chezmoi, mise.

## First step

Clone this repository, brew install with `Brewfile`.

```bash
brew install
```

## Supported Platforms

- [x] MacOS
- [ ] Linux
- [ ] Windows

## Apply config

```bash
chezmoi apply
```

## Keyboardio Atreus

My [Keyboardio Atreus](https://shop.keyboard.io/products/keyboardio-atreus) firmware is [kaleidoscope](https://github.com/keyboardio/Kaleidoscope).

Clone repository by [ghq](https://github.com/x-motemen/ghq) like,

```bash
ghq get git@github.com:keyboardio/Kaleidoscope.git`
```

Then, move to `keyboards/keyboardio/atreus` and flash by `./compile.sh && flash.sh` .
