{ ... }:

{
  networking.computerName = "ShadowComet";
  networking.hostName = "ShadowComet";
  networking.localHostName = "ShadowComet";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # MacBook Air 固有の設定はこのモジュールに追加する。
  system.stateVersion = 7;
}
