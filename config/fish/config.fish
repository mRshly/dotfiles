if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g theme_display_git yes
    set -g theme_display_git_dirty yes
    set -g theme_display_git_untracked yes
    set -g theme_display_git_ahead_verbose yes
    set -g theme_display_git_dirty_verbose yes
    set -g theme_display_git_stashed_verbose yes
    set -g theme_display_git_default_branch yes
    set -g theme_git_default_branches develop
    set -g theme_git_worktree_support yes
    set -g theme_use_abbreviated_branch_name no
    set -g theme_display_vagrant no
    set -g theme_display_docker_machine yes
    set -g theme_display_k8s_context yes
    set -g theme_display_hg yes
    set -g theme_display_virtualenv yes
    set -g theme_display_nix no
    set -g theme_display_ruby no
    set -g theme_display_go verbose
    set -g theme_display_node yes
    set -g theme_display_user ssh
    set -g theme_display_hostname ssh
    set -g theme_display_vi yes
    set -g theme_display_date yes
    set -g theme_display_cmd_duration yes
    # Title options
    set -g theme_title_display_process yes
    set -g theme_title_display_path no
    set -g theme_title_display_user no
    set -g theme_title_use_abbreviated_path no
    set -g theme_display_user yes
    set -g theme_date_timezone Asia/Tokyo
    set -g theme_avoid_ambiguous_glyphs yes
    set -g theme_powerline_fonts yes
    set -g theme_nerd_fonts yes
    set -g theme_show_exit_status yes
    set -g theme_display_jobs_verbose yes
    set -g theme_color_scheme terminal-dark
    set -g fish_prompt_pwd_dir_length 1
    set -g theme_project_dir_length 1
    set -g theme_newline_cursor yes
    set -g theme_newline_prompt '> '
    # see https://github.com/wez/wezterm/issues/415#issuecomment-755849623
    set -x TERM wezterm
    set -gx EDITOR nvim
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


# poetry
fish_add_path $HOME/.local/bin

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
