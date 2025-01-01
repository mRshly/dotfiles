{ config, ... }:
{
  home.sessionVariables.XDG_CONFIG_HOME = "$HOME/.config";
  programs.lazygit = {
    enable = true;
    settings = {
      customCommand = [
        {
          key = "C";
          command = "git cz";
          description = "commit with commitizen";
          context = "files";
          loadingText = "opening commitizen commit tool";
          subprocess = true;
        }
      ];
    };
  };
  xdg.configFile."lazygit/config.yml".source = ./config.yml;
}
