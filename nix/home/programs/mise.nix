{ pkgs, ... }:

{
  programs.mise = {
    enable = true;
    package = pkgs.mise;
    enableFishIntegration = true;

    # mise はプロジェクト単位のバージョン管理とタスクランナーとして使う。
    # グローバルに置くのは nixpkgs へ移せていないものだけに絞る。
    # node / pnpm / yarn / uv / rust は nix/home/packages.nix へ移行済み。
    # usage は mise のシェル補完を生成するための部品なので残す。
    globalConfig = {
      tools = {
        usage = "latest";
      };
    };
  };
}
