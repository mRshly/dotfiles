{ config, lib, pkgs, ... }:

# npm / PyPI から取得するパッケージは flake.lock の保護外なので、
# サプライチェーン攻撃の対策をパッケージマネージャ側で行う。
#   - 公開から 7 日未満のリリースは解決しない。乗っ取られたアカウントからの
#     悪性リリースは数時間〜数日で検知・削除されることが多いため。
#   - 依存パッケージの install script を実行しない。
# 緊急のセキュリティ修正など 7 日を待てない場合は、プロジェクト側の設定か
# コマンドライン引数で個別に上書きする。
# 本体 (nodejs / pnpm / yarn-berry / uv) は packages.nix で管理する。
#
# 値を変えたら README の表も更新すること。nix flake check
# (nix/checks/package-manager-policy.nix) が不一致を検出する。
let
  minimumReleaseAgeDays = 7;
  minimumReleaseAgeMinutes = minimumReleaseAgeDays * 24 * 60;

  yamlFormat = pkgs.formats.yaml { };

  npm = config.programs.npm.settings;
  pnpm = config.programs.pnpm.settings;
  yarn = config.programs.yarn.settings;
  uv = config.programs.uv.settings;

  uvExcludeNewerDays =
    let
      m = builtins.match "([0-9]+) days" (uv.exclude-newer or "");
    in
    if m == null then 0 else lib.toInt (builtins.head m);
in
{
  # Home Manager に pnpm モジュールが無いため、他のツールと同じく設定値を
  # config から参照できるようにローカルで定義する。upstream に追加されて
  # 衝突したらそちらへ移行する。
  options.programs.pnpm.settings = lib.mkOption {
    inherit (yamlFormat) type;
    default = { };
    description = "pnpm のグローバル設定。$XDG_CONFIG_HOME/pnpm/config.yaml に書き出す。";
  };

  config = {
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
    programs.pnpm.settings = {
      minimumReleaseAge = minimumReleaseAgeMinutes;
      strictDepBuilds = true;
    };
    xdg.configFile."pnpm/config.yaml" = lib.mkIf (pnpm != { }) {
      source = yamlFormat.generate "pnpm-config" pnpm;
    };

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

    # README との一致だけでは、両方を揃えて緩めた変更を検出できない。
    # 7 日・install script 無効を下限として build 時に強制する。
    assertions = [
      {
        assertion = (npm.ignore-scripts or false) == true && (npm.min-release-age or 0) >= 7;
        message = "programs.npm.settings: ignore-scripts = true と min-release-age >= 7 (日) が必要です。";
      }
      {
        assertion = (pnpm.strictDepBuilds or false) == true && (pnpm.minimumReleaseAge or 0) >= 7 * 24 * 60;
        message = "programs.pnpm.settings: strictDepBuilds = true と minimumReleaseAge >= 10080 (分) が必要です。";
      }
      {
        assertion = (yarn.enableScripts or true) == false && (yarn.npmMinimalAgeGate or 0) >= 7 * 24 * 60;
        message = "programs.yarn.settings: enableScripts = false と npmMinimalAgeGate >= 10080 (分) が必要です。";
      }
      {
        assertion = uvExcludeNewerDays >= 7;
        message = ''programs.uv.settings: exclude-newer = "<N> days" (N >= 7) が必要です。'';
      }
    ];
  };
}
