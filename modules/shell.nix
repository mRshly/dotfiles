{ ... }:
{
  imports = [
    ./fish
    ./starship.nix
    ./bat.nix
  ];

  programs.zoxide.enable = true;
}
