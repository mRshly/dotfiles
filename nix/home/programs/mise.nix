{ pkgs, ... }:

{
  programs.mise = {
    enable = true;
    package = pkgs.mise;
    enableFishIntegration = true;

    # mise はプロジェクト単位のバージョン管理とタスクランナーとして使う。
    # グローバルに置くのは nixpkgs へ移せていないものだけに絞る。
    # node / pnpm / yarn は nix/home/packages.nix へ移行済み。
    globalConfig = {
      tools = {
        pipx = "latest";
        rust = "latest";
        rust-analyzer = "latest";
        uv = "latest";
        usage = "latest";
      };
    };
  };
}
