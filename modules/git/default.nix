{ pkgs, lib, ... }:
{
  programs.git = {
    enable = true;
    delta.enable = true;
    userName = "mrshly";
    userEmail = "mshrm808@icloud.com";
    extraConfig = {
      core = {
        editor = "nvim";
        # pager = "delta";
        interactive.diffFilter = "delta --color-only";
        delta.line-numbers = true;
        delta.navigate = true;
        merge.conflictstyle = "diff3";
        diff.colorMoved = "default";
      };
    };
  };
}
