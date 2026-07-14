{ ... }:

{
  programs.git = {
    enable = true;
    # settings は旧 extraConfig (pinned home-manager でリネーム済み)。
    # 生成先は ~/.config/git/config。~/.gitconfig に同じキーが残っていると
    # そちらが優先されるため、重複キーの掃除は first-switch-checklist を参照。
    settings = {
      core.editor = "nvim";
      merge.tool = "nvimdiff";
      mergetool = {
        prompt = false;
        keepBackup = false;
        nvimdiff.layout = "LOCAL,BASE,REMOTE /MERGED";
      };
    };
  };
}
