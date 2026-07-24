{ pkgs, ... }:

{
  programs.mise = {
    enable = true;
    package = pkgs.mise;
    enableFishIntegration = true;

    settings = {
      # mise 自身の新バージョン通知を止める。nixpkgs 管理なので self-update
      # できず、警告に従えないまま出続けるため。更新は flake.lock で行う。
      # quiet は進捗表示と WARN のみを抑制し、mise ls などの出力は残る。
      quiet = true;
    };

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
