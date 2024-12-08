{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mrshly";
  home.homeDirectory = "/Users/mrshly";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.ripgrep
    pkgs.fd
    pkgs.fish
    pkgs.starship
    pkgs.eza
    pkgs.bat
    pkgs.bat-extras.batdiff
    pkgs.bat-extras.batgrep
    pkgs.bat-extras.batman
    pkgs.bat-extras.prettybat
    pkgs.mise
    pkgs.fzf
    pkgs.git
    pkgs.gh
    pkgs.delta
    pkgs.commitizen
    pkgs.lazygit

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

# programs.bash = {
#   interactiveShellInit = ''
#     if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
#     then
#       shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
#       exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
#     fi
#   '';
# };
programs.git = {
    enable = true;
    delta.enable = true;
    userName = "mRshly";
    userEmail = "mshrm808@icloud.com";
    extraConfig = {
      user.signingKey = "~/.ssh/id_ed25519";
      lfs = {
        enable = true;
      };
      core = {
        editor = "nvim";
      };
      delta = {
        navigate = true;
        line-numbers = true;
        minus-style = "syntax '#37222c'";
        minus-non-emph-style = "syntax '#37222c'";
        minus-emph-style = "syntax '#713137'";
        minus-empty-line-marker-style = "syntax '#b2555b'";
        line-numbers-minus-style = "#b2555b";
        plus-style = "syntax '#20303b'";
        plus-non-emph-style = "syntax '#20303b'";
        plus-emph-style = "syntax '#2c5a66'";
        plus-empty-line-marker-style = "syntax '#20303b'";
        line-numbers-plus-style = "#266d6a";
        line-numbers-zero-style = "#3b4261";
      };
      merge = {
        conflictstyle = "diff3";
        tool = "nvimdiff";
      };
      diff = {
        colorMoved = "default";
      };
      mergetool = {
        prompt = false;
        keepBackup = false;
      };
      mergetool-nvimdiff = {
        layout = "LOCAL,BASE,REMOTE /MERGED";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };

programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      fish_add_path -p ~/.nix-profile/bin /nix/var/nix/profiles/default/bin
      set -a fish_complete_path ~/.nix-profile/share/fish/completions/ ~/.nix-profile/share/fish/vendor_completions.d/
      set -x TERM wezterm
      set -gx EDITOR nvim
      set -gx MANPAGER sh -c 'col -bx | bat -l man -p'
    '';
    shellAliases = {
      bathelp = "bat --plain --language=help";
    };
    shellAbbrs = {
      # pusdh /popd
      pu = "pushd";
      po = "popd";
      # docker
      dc = "docker compose";
      # git
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
      # eza
      la = "eza --icons --git -al -s Name";
      ll = "eza --icons --git -l -s Name";
      lar = "eza --icons --git -al --time-style relative -s Name ";
      llr = "eza --icons --git -l --time-style relative -s Name ";
      lt = "eza --icons --time-style relative --git -lT -L 2 -s Name";
    };
    shellInit = ''
      function fish_user_key_bindings
        # Execute this once per mode that emacs bindings should be used in
        fish_default_key_bindings -M insert

        # Then execute the vi-bindings so they take precedence when there's a conflict.
        # Without --no-erase fish_vi_key_bindings will default to
        # resetting all bindings.
        # The argument specifies the initial mode (insert, "default" or visual).
        fish_vi_key_bindings insert
      end
      source (dirname (status --current-filename))/config.local.fish
      # nvim
      export XDG_CONFIG_HOME=$HOME/.config
      # mise
      mise activate fish | source
      # 1Password
      switch (uname)
          case Darwin
              op completion fish | source
              set -gx SSH_AUTH_SOCK $HOME/.1password/agent.sock
      end
      # nvm
      if test -e ~/.nvm/nvm.sh
          load_nvm >/dev/stderr
      end
      # starship
      starship init fish | source
    '';
    plugins = [
      {
        name = "z";
        src = pkgs.fishPlugins.z;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish;
      }
      {
        name = "fish-bass";
        src = pkgs.fishPlugins.bass;
      }
    ];
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
