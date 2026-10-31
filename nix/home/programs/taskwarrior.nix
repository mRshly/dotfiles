{ pkgs, ... }:

{
  # herdr 上のエージェント同士と人が共有するタスクボード。
  # 生成先は ~/.config/task/home-manager-taskrc で、可変の ~/.config/task/taskrc
  # から include される。データは ~/.local/share/task (SQLite) に置かれる。
  programs.taskwarrior = {
    enable = true;
    # module の既定は taskwarrior2 のため明示する。3 系はストレージが
    # TaskChampion (SQLite) になり、複数エージェントの同時書き込みに強い。
    package = pkgs.taskwarrior3;
    config = {
      # エージェントは TTY を持たないので確認プロンプトを一切出さない。
      confirmation = false;
      recurrence.confirmation = false;
      bulk = 0;
      # アップグレード毎の news 催促を抑止する。バージョンは package から取る。
      news.version = pkgs.taskwarrior3.version;

      # 担当エージェント。herdr のエージェント名 ([a-z][a-z0-9_-]{0,31}) を入れる。
      # 人が担当する場合は "human" とする。
      uda.agent = {
        type = "string";
        label = "Agent";
      };

      # 担当者込みの一覧。`task board` / `task board agent:py-support`
      report.board = {
        description = "Pending tasks with herdr agent assignment";
        columns = [
          "id"
          "start.active"
          "agent"
          "project"
          "tags"
          "depends.indicator"
          "urgency"
          "description.count"
        ];
        labels = [
          "ID"
          "A"
          "Agent"
          "Project"
          "Tags"
          "D"
          "Urg"
          "Description"
        ];
        filter = "status:pending -WAITING";
        sort = "start-,urgency-";
      };

      # エージェント運用上の優先度: question > review > followup > agent。
      # 既定値は active 4.0 / blocking 8.0 / due 12.0 / tags 1.0。
      # 人の回答待ちは due 並みに上げ、エージェントの手を止めたままにしない。
      urgency.user.tag.question.coefficient = 12.0;
      # 完了済みの作業を滞留させないよう、start 済みより上に出す。
      urgency.user.tag.review.coefficient = 6.0;
      urgency.user.tag.followup.coefficient = 2.0;
      # 担当者が決まっていることは小さく加点するだけにする。
      urgency.uda.agent.coefficient = 1.0;
    };
  };
}
