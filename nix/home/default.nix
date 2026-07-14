{ ... }:

{
  imports = [
    ./packages.nix
    ./programs/fish.nix
    ./programs/git.nix
    ./programs/mise.nix
  ];

  home.username = "shadowcomet";
  home.homeDirectory = "/Users/shadowcomet";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
