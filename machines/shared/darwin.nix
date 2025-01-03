{ pkgs, ... }:
{
  nixpkgs.config = {
    allowUnfree = true;
  };
  services = {
    nix-daemon = {
      enable = true;
    };
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

  security.pam.enableSudoTouchIdAuth = true;

  users.users.mrshly = {
    name = "mrshly";
    home = "/Users/mrshly";
  };

  homebrew = {
    enable = true;
    brews = [
      "commitizen"
      "lazygit"
    ];
    casks = [
      "1password"
      "1password-cli"
      "alfred"
      "arduino-ide"
      "discord"
      "firefox"
      "font-hackgen"
      "font-hackgen-nerd"
      "google-chrome"
      "obsidian"
      "raycast"
      "rectangle"
      "spotify"
      "visual-studio-code"
      "vivaldi"
      "vlc"
      "wezterm"
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
    };
  };
}
