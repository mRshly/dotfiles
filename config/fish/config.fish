if status is-interactive
    # see https://github.com/wez/wezterm/issues/415#issuecomment-755849623
    set -x TERM wezterm
    set -gx EDITOR nvim
    set -gx KALEIDOSCOPE_DIR $HOME/ghq/github.com/keyboardio/Kaleidoscope
end

function fish_user_key_bindings
    # Execute this once per mode that emacs bindings should be used in
    fish_default_key_bindings -M insert

    # Then execute the vi-bindings so they take precedence when there's a conflict.
    # Without --no-erase fish_vi_key_bindings will default to
    # resetting all bindings.
    # The argument specifies the initial mode (insert, "default" or visual).
    fish_vi_key_bindings insert
end

# abbreviations
source (dirname (status --current-filename))/abbr.fish

# brew
switch (uname)
    case Darwin
        switch (uname -m)
            case arm64
                fish_add_path /opt/homebrew/bin
                fish_add_path /opt/homebrew/sbin
                eval "$(/opt/homebrew/bin/brew shellenv)"
            case x86_64
                fish_add_path /usr/local/bin
                fish_add_path /usr/local/sbin
                eval "$(/usr/local/bin/brew shellenv)"
        end
    case Linux
        fish_add_path /home/linuxbrew/.linuxbrew/bin
        fish_add_path /home/linuxbrew/.linuxbrew/sbin
end

# mise
mise activate fish | source

# 1Password
switch (uname)
    case Darwin
        op completion fish | source
        set -gx SSH_AUTH_SOCK $HOME/.1password/agent.sock
end


# nvim
export XDG_CONFIG_HOME=$HOME/.config

# bat
## https://github.com/sharkdp/bat?tab=readme-ov-file#man
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
## https://github.com/sharkdp/bat?tab=readme-ov-file#highlighting---help-messages
alias bathelp='bat --plain --language=help'

if test -e ~/.nvm/nvm.sh
    load_nvm >/dev/stderr
end

# starship
starship init fish | source
