{ ... }:
{
  home.username = "mrshly";
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.nix-index.enable = true;

  home.sessionVariables = {
    PROJECTS = "$HOME/Developer";
    XDG_CONFIG_HOME = "$HOME/.config";
  };

  home.activation.developer = ''
    mkdir -p ~/Developer
  '';
}
