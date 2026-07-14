{ pkgs, username, userUid, ... }:

{
  imports = [
    ./homebrew.nix
  ];

  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    vim
  ];

  # users.knownUsers に含まれないユーザーの shell 設定は黙って無視される。
  users.knownUsers = [ username ];
  users.users.${username} = {
    uid = userUid;
    home = "/Users/${username}";
    shell = pkgs.fish;
  };

  system.primaryUser = username;
}
