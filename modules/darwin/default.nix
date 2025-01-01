{ ... }:
{
  home.homeDirectory = "/Users/mrshly";

  programs.fish.shellInit = ''
    fish_add_path -a ~/Applications/Ghostty.app/Contents/MacOS/
    fish_add_path -a /opt/homebrew/bin/
  '';
}
