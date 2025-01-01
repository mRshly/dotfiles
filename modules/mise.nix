{ ... }:
{
  programs.mise = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      activate_aggressive = true;
    };
    globalConfig = {
      tools = {
        usage = "latest";
        node = "latest";
        rust = "latest";
        rust-analyzer = "latest";
        go = "latest";
        pnpm = "latest";
        yarn = "latest";
        uv = "latest";
      };
    };
  };

}
