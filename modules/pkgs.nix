{ pkgs, lib, ... }:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
  home.packages =
    with pkgs;
    with pkgs.nodePackages_latest;
    [
      curl
      eza
      fd
      ghq
      jq
      ripgrep
      wget

      # treesitter, lsps, formatters, etc
      nixfmt-rfc-style
    ];
}
