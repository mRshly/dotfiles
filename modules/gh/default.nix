{ config, pkgs, ... }:
{
  programs.gh = {
    enable = true;
    settings = {
      version = "1";
      aliases = {
        co = "pr checkout";
      };
      prompt = "enabled";
      editor = "nvim";
      git_protocol = "ssh";
      pager = "delta -s";
    };
  };
}
