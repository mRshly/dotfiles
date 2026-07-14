{ username, ... }:

{
  imports = [
    ./packages.nix
    ./programs/fish.nix
    ./programs/git.nix
    ./programs/mise.nix
  ];

  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "26.05";

  # macOS では man-db パッケージを使わないため、キャッシュ生成も行わない。
  programs.man.generateCaches = false;
  programs.home-manager.enable = true;
}
