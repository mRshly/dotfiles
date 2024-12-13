{ ... }:
{
  programs.bat = {
    enable = true;
    config = {
      theme = "Solarized (dark)";
      pager = "less --RAW-CONTROL-CHARS --quit-if-one-screen --mouse";
    };
  };
}

