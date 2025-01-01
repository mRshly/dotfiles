{ config, ... }:
{
  # programs.wezterm = {
  #   enable = true;
  #   # NOTE: can't read split config files
  #   extraConfig = builtins.readFile ./config/wezterm.lua;
  # };

  xdg.configFile."wezterm" = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
