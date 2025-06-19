status is-interactive; and begin
    set fish_greeting
    set -U XDG_CONFIG_HOME $HOME/.config
    fish_add_path -p ~/.local/bin
    fish_config theme choose "Solarized Dark"
end

# abbreviations
source (dirname (status --current-filename))/abbr.fish

# Vim key bind
function fish_user_key_bindings
    # Execute this once per mode that emacs bindings should be used in
    fish_default_key_bindings -M insert

    # Then execute the vi-bindings so they take precedence when there's a conflict.
    # Without --no-erase fish_vi_key_bindings will default to
    # resetting all bindings.
    # The argument specifies the initial mode (insert, "default" or visual).
    fish_vi_key_bindings insert
end

# mise
mise completion fish >~/.config/fish/completions/mise.fish
mise activate | source

# 1Password
op completion fish | source
set -gx SSH_AUTH_SOCK $HOME/.1pasword/agent.sock

# bat
# https://github.com/sharkdp/bat/issues/3053
set -gx MANPAGER "sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
set -gx EDITOR nvim

# Ghostty
fish_add_path -a ~/Applications/Ghostty.app/Contents/MacOS/

# Homebrew
set -gx LDFLAGS -L/opt/homebrew/opt/libffi/lib
set -gx CPPFLAGS -I/opt/homebrew/opt/libffi/include
set -gx PKG_CONFIG_PATH "$(brew --prefix)/lib/pkgconfig:$(brew --prefix)/share/pkgconfig:$PKG_CONFIG_PATH"
fish_add_path -a /opt/homebrew/bin/

# Starship
function starship_transient_prompt_func
    echo
    starship module character
end
starship init fish | source

# Orbstack
fish_add_path -p ~/.orbstack/bin

# KALEIDOSCOPE
set -gx KALEIDOSCOPE_DIR $HOME/ghq/github.com/keyboardio/Kaleidoscope
