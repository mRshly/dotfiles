{ pkgs, ... }:

{
  imports = [
    ../../darwin/homebrew.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    vim
  ];

  # users.knownUsers に含まれないユーザーの shell 設定は黙って無視される。
  # uid は `id -u shadowcomet` で確認済みの値。
  users.knownUsers = [ "shadowcomet" ];
  users.users.shadowcomet = {
    uid = 501;
    home = "/Users/shadowcomet";
    shell = pkgs.fish;
  };

  system.primaryUser = "shadowcomet";
  system.stateVersion = 7;
}
