{ ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      character.success_symbol = "> ";
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
