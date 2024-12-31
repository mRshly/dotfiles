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
  nix.settings.truested-users = [
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
    casks = [
      "1password"
    ];
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
