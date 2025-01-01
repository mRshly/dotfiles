{ ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format = ''
        $all
      '';
    };
  };
  programs.fish.interactiveShellInit = "
    function starship_transient_prompt_func
      echo
      starship module character
    end
  ";
}
