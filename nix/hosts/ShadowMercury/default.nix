{ ... }:

{
  networking.computerName = "ShadowMercury";
  networking.hostName = "ShadowMercury";
  networking.localHostName = "ShadowMercury";

  # Determinate が Nix デーモンを管理するため、nix-darwin とは二重管理しない。
  nix.enable = false;

  # M4 Mac mini 固有の設定はこのモジュールに追加する。
  system.stateVersion = 7;
}
