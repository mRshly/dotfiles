if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g theme_display_git yes
    set -g theme_display_git_dirty yes
    set -g theme_display_git_untracked no
    set -g theme_display_git_ahead_verbose yes
    set -g theme_display_git_dirty_verbose yes
    set -g theme_display_git_stashed_verbose yes
    set -g theme_display_git_default_branch yes
    set -g theme_git_default_branches develop
    set -g theme_git_worktree_support yes
    set -g theme_use_abbreviated_branch_name yes
    set -g theme_display_vagrant no
    set -g theme_display_docker_machine yes
    set -g theme_display_k8s_context yes
    set -g theme_display_hg yes
    set -g theme_display_virtualenv yes
    set -g theme_display_nix no
    set -g theme_display_ruby no
    set -g theme_display_node yes
    set -g theme_display_user ssh
    set -g theme_display_hostname ssh
    set -g theme_display_vi no
    set -g theme_display_date yes
    set -g theme_display_cmd_duration yes
    set -g theme_title_display_process yes
    set -g theme_title_display_path no
    set -g theme_title_display_user yes
    set -g theme_title_use_abbreviated_path no
    # set -g theme_date_format "+%a %H:%M"
    set -g theme_date_timezone America/Los_Angeles
    set -g theme_avoid_ambiguous_glyphs yes
    set -g theme_powerline_fonts yes
    set -g theme_nerd_fonts yes
    set -g theme_show_exit_status yes
    set -g theme_display_jobs_verbose yes
    set -g default_user mushroom-air
    set -g theme_color_scheme node
    set -g fish_prompt_pwd_dir_length 1
    set -g theme_project_dir_length 0
    set -g theme_newline_cursor no
    set -g theme_newline_prompt '$ '
    set -x VIRTUAL_ENV_DISABLE_PROMPT 1
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

## nvim
abbr --add vim nvim

## docker
abbr --add dc docker compose

## git
abbr --add g git
abbr --add ga git add
abbr --add gb git branch
abbr --add gc git commit
abbr --add gd git diff
abbr --add gl git log
abbr --add gp git push origin
abbr --add gcb git checkout -b
abbr --add gcz git cz
abbr --add gsh git show
abbr --add gst git status
abbr --add gsw git switch


# mise
mise activate fish | source

# 1Password
op completion fish | source
set -gx SSH_AUTH_SOCK $HOME/.1password/agent.sock

# poetry
fish_add_path $HOME/.local/bin

# nvim
export XDG_CONFIG_HOME=$HOME/.config

# starship
starship init fish | source
