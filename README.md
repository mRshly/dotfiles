# dotfiles

## Python

based on [fredrikaverpil/dotfiles]( https://github.com/fredrikaverpil/dotfiles/tree/main/nvim-lazyvim )

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
    + poetry = { version="latst", pyproject="pyproject.toml"}
    ```

## Create Symbolic link

```bash
ln -s ~/dotfiles/config/<package> ~/.config/<package>
```
