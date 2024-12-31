{ ... }:
{
  home.username = "mrshly";
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.nix-index.enable = true;

  home.sessionVariables = {
    PROJECTS = "$HOME/Developer";
  };

  home.activation.developer = ''
    mkdir -p ~/Developer
  '';
}
