{ pkgs, ... }:
{
  nixpkgs.config = {
    allowUnfree = true;
  };
  nix.package = pkgs.nix;
  nix.settings.trusted-users = [
    "root"
    "mrshly"
  ];
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  system.stateVersion = 5;

  users.users.mrshly = {
    name = "mrshly";
    home = "/Users/mrshly";
  };

  homebrew = {
    enable = true;
    brews = [
      "commitizen"
      "lazygit"
      "mise"
    ];
    casks = [
      "1password"
      "1password-cli"
      "alfred"
      "arduino-ide"
      "brave-browser"
      "cursor"
      "discord"
      "firefox"
      "font-hackgen"
      "font-hackgen-nerd"
      "foobar2000"
      "google-chrome"
      "obsidian"
      "orbstack"
      "raycast"
      "rectangle"
      "spotify"
      "steam"
      "visual-studio-code"
      "vivaldi"
      "vlc"
      "wezterm"
      "zen-browser"
    ];
    masApps = {
      "Bumpr" = 1166066070;
      "Deliveries" = 290986013;
      "Goodnotes" = 1444383602;
      "Kindle" = 302584613;
      "Reeder Classic" = 1529448980;
      "RunCat" = 1429033973;
      "The Unarchiver" = 425424353;
    };
  };

  system = {
    defaults = {
      dock = {
        autohide = true;
        autohide-delay = 0.0;
        orientation = "bottom";
        tilesize = 42;
        showhidden = true;
        show-recents = true;
        show-process-indicators = true;
        expose-animation-duration = 0.1;
        expose-group-apps = true;
      };
      NSGlobalDomain = {
        AppleKeyboardUIMode = 3;
        NSAutomaticCapitalizationEnabled = false;
        AppleInterfaceStyle = "Dark";
      };
      finder = {
        AppleShowAllFiles = true;
        ShowStatusBar = true;
        ShowPathbar = true;
      };
    };
    startup = {
      chime = false;
    };
  };
}
