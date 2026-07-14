{ pkgs, ... }:

{
  programs.mise = {
    enable = true;
    package = pkgs.mise;
    enableFishIntegration = true;

    globalConfig = {
      tools = {
        pipx = "latest";
        pnpm = "latest";
        rust = "latest";
        rust-analyzer = "latest";
        uv = "latest";
        yarn = "latest";
        node = "latest";
        usage = "latest";
      };
    };
  };
}
