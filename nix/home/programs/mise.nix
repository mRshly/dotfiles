{ pkgs, ... }:

{
  programs.mise = {
    enable = true;
    package = pkgs.mise;
    enableFishIntegration = true;

    # mise はプロジェクト単位のバージョン管理とタスクランナーとして使う。
    # グローバルに置くのは nixpkgs へ移せていないものだけに絞る。
    # node / pnpm / yarn / uv は nix/home/packages.nix へ移行済み。
    globalConfig = {
      tools = {
        rust = "latest";
        rust-analyzer = "latest";
        usage = "latest";
      };
    };
  };
}
