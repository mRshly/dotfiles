{ pkgs, ... }:
{
  programs.bat = {
    enable = true;
    config = {
      theme = "Solarized (dark)";
      pager = "less --RAW-CONTROL-CHARS --quit-if-one-screen --mouse";
    };
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
      batpipe
      prettybat
    ];
  };
}
