{ ... }:

# npm / PyPI から取得するパッケージは flake.lock の保護外なので、
# サプライチェーン攻撃の対策をパッケージマネージャ側で行う。
#   - 公開から 7 日未満のリリースは解決しない。乗っ取られたアカウントからの
#     悪性リリースは数時間〜数日で検知・削除されることが多いため。
#   - 依存パッケージの install script を実行しない。
# 緊急のセキュリティ修正など 7 日を待てない場合は、プロジェクト側の設定か
# コマンドライン引数で個別に上書きする。
# 本体 (nodejs / pnpm / yarn-berry / uv) は packages.nix で管理する。
let
  minimumReleaseAgeDays = 7;
  minimumReleaseAgeMinutes = minimumReleaseAgeDays * 24 * 60;
in
{
  programs.npm = {
    enable = true;
    package = null;
    settings = {
      # pre / post script も止まるが、npm run などで明示したスクリプト自体は動く。
      ignore-scripts = true;
      min-release-age = minimumReleaseAgeDays;
    };
  };

  # pnpm 10 以降は依存の build script をデフォルトで実行しない。
  # strictDepBuilds で、未承認の build script を警告ではなくエラーにする。
  xdg.configFile."pnpm/config.yaml".text = ''
    minimumReleaseAge: ${toString minimumReleaseAgeMinutes}
    strictDepBuilds: true
  '';

  # yarn 4 はどちらもデフォルトで安全側だが、意図を明示するため固定する。
  programs.yarn = {
    enable = true;
    settings = {
      enableScripts = false;
      npmMinimalAgeGate = minimumReleaseAgeMinutes;
    };
  };

  programs.uv = {
    enable = true;
    package = null;
    settings = {
      exclude-newer = "${toString minimumReleaseAgeDays} days";
    };
  };
}
