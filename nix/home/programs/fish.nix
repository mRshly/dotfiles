{ ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableTransience = true;
  };

  programs.fish = {
    enable = true;

    functions = {
      # Vim キーバインド (insert モード開始、emacs バインドを下敷きにする)
      fish_user_key_bindings = ''
        fish_default_key_bindings -M insert
        fish_vi_key_bindings insert
      '';

      # Starship transient prompt
      starship_transient_prompt_func = ''
        echo
        starship module character
      '';
    };

    interactiveShellInit = ''
      set fish_greeting
      set -gx XDG_CONFIG_HOME $HOME/.config
      fish_add_path -p ~/.local/bin

      # テーマファイル (~/.config/fish/themes/) は chezmoi 管理のまま
      fish_config theme choose solarized_osaka_dark

      if test -f ~/.config/fish/abbr.fish
          source ~/.config/fish/abbr.fish
      end

      # ghq_repo_browser は chezmoi 管理の
      # ~/.config/fish/functions/ghq_repo_browser.fish から autoload される
      bind alt-g ghq_repo_browser
      bind -M insert alt-g ghq_repo_browser

      function wezterm_osc7 --on-variable PWD
          printf "\e]7;file://%s%s\a" (hostname) $PWD
      end
      wezterm_osc7

      if type -q op
          op completion fish | source
      end

      set -gx SSH_AUTH_SOCK $HOME/.1password/agent.sock
      set -gx MANPAGER "sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
      set -gx EDITOR nvim
      fish_add_path -a ~/Applications/Ghostty.app/Contents/MacOS/
      fish_add_path -p ~/.orbstack/bin
      set -gx KALEIDOSCOPE_DIR $HOME/ghq/github.com/keyboardio/Kaleidoscope

      if type -q atuin
          set -gx ATUIN_NOBIND true
          atuin init fish | source
          bind \cr _atuin_search
          bind -M insert \cr _atuin_search
      end

      if type -q devbox
          devbox global shellenv --init-hook | source
      end

      if test -e ~/.orbstack/shell/init2.fish
          source ~/.orbstack/shell/init2.fish
      end
    '';
  };
}
