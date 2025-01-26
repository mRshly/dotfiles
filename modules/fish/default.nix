{ pkgs, config, ... }:
{
  programs.fish = {
    enable = true;
    shellInit = ''
      if test -f ~/.localrc.fish
        source ~/.localrc.fish
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

      mise completion fish > ~/.config/fish/completions/mise.fish

      op completion fish | source
      set -gx SSH_AUTH_SOCK $HOME/.1pasword/agent.sock

      # https://github.com/sharkdp/bat/issues/3053
      set -gx MANPAGER "sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
      set -gx EDITOR nvim
    '';
    interactiveShellInit = ''
      # disable fish greeting
      set fish_greeting
      fish_add_path -p ~/.nix-profile/bin /nix/var/nix/profiles/default/bin
      fish_add_path -p ~/.orbstack/bin
      fish_add_path -p ~/.local/bin
      set -a fish_complete_path ~/.nix-profile/share/fish/completions/ ~/.nix-profile/share/fish/vendor_completions.d/
      set -U XDG_CONFIG_HOME $HOME/.config
      fish_config theme choose "Solarized Dark"
      set -gx KALEIDOSCOPE_DIR $HOME/ghq/github.com/keyboardio/Kaleidoscope
    '';
    shellAliases = {
      bathelp = "bat --plain --language=help";
    };
    shellAbbrs = {
      # pushd / popd
      pu = "pushd";
      po = "popd";

      # specific directory
      dot = "z dotfiles";
      atreus = "z atreus";

      vim = "nvim";

      dc = "docker compose";

      g = "git";
      ga = "git add";
      gb = "git branch";
      gc = "git commit";
      gd = "git diff";
      gl = "git log --graph --pretty='format:%C(yellow)%h%C(reset) %s %C(magenta)%cr%C(reset)%C(auto)%d%C(reset)'";
      gp = "git push origin";
      gcb = "git checkout -b";
      gch = "git checkout";
      gcz = "git cz";
      gsh = "git show";
      gst = "git status";
      gsw = "git switch";
      lg = "lazygit";

      ## eza
      la = "eza --icons --git -al -s Name";
      ll = "eza --icons --git -l -s Name";
      lar = "eza --icons --time-style relative --git -al -s Name";
      llr = "eza --icons --time-style relative --git -l -s Name";
      lt = "eza --icons --time-style relative --git -lT -L 2 -s Name";

      ## broot
      br = "broot -sghd";
    };
    plugins = [
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
    ];
  };
}
