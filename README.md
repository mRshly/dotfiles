# dotfiles

## Python 🐍

Based on [fredrikaverpil/dotfiles]( https://github.com/fredrikaverpil/dotfiles/tree/main/nvim-lazyvim )

## Copilot in Neovim 🤖

First, setup copilot in `neovim` with `:Copilot setup` command.

## Mise

### Setup poetry

I choose to use poetry in each python project.

Describe below is the setup poetry for each python project.

1. Generate `.mise.local.toml` file.

    ```bash
    cd <python-project>
    mise use --env local poetry@latest
    ```

2. Change `.mise.local.toml` to [ automatic activate poetry ](https://github.com/mise-plugins/mise-poetry?tab=readme-ov-file#virtualenv-activation).

    ```diff
    [tools]
    - poetry = "latest"
    + poetry = { version="latest", pyproject="pyproject.toml"}
    ```

## Create Symbolic link

```bash
ln -s ~/dotfiles/config/<package> ~/.config/<package>
```
