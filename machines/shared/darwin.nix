{ pkgs, ... }:
{
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
      "alfred"
      "discord"
      "font-hack"
      "firefox"
      "google-chrome"
      "vivaldi"
      "vlc"
    ];
  };
}
