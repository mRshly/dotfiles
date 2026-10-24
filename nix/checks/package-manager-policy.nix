# README の「Package manager quarantine」の表が、Home Manager で宣言した
# 実際の設定値と一致しているかを検査する。nix flake check から呼ばれる。
{ pkgs, lib, hmConfig, readme }:

let
  marker = "package-manager-policy";

  render = v:
    if lib.isBool v then lib.boolToString v
    else if lib.isString v then v
    else toString v;

  # Home Manager が実際にそのパスへ配置するかどうか。home.file のキーは
  # モジュールの実装次第で相対・絶対パスが混在するため、配置先の target で判定する。
  # xdg.configFile も home.file に合流し、target はホームからの相対パスになる。
  deployed = file:
    lib.any (f: f.target == lib.removePrefix "~/" file) (lib.attrValues hmConfig.home.file);

  # 各ツールの設定ファイルの書式で 1 項目を表示する。
  tools = [
    {
      name = "npm";
      file = "~/.npmrc";
      settings = hmConfig.programs.npm.settings;
      show = k: v: "${k}=${render v}";
    }
    {
      name = "pnpm";
      file = "~/.config/pnpm/config.yaml";
      settings = hmConfig.programs.pnpm.settings;
      show = k: v: "${k}: ${render v}";
    }
    {
      name = "yarn";
      file = "~/.yarnrc.yml";
      settings = hmConfig.programs.yarn.settings;
      show = k: v: "${k}: ${render v}";
    }
    {
      name = "uv";
      file = "~/.config/uv/uv.toml";
      settings = hmConfig.programs.uv.settings;
      show = k: v: if lib.isString v then ''${k} = "${v}"'' else "${k} = ${render v}";
    }
  ];

  row = t:
    assert lib.assertMsg (deployed t.file) "${t.name}: ${t.file} が Home Manager で配置されていません。";
    let
      cells = lib.mapAttrsToList (k: v: "`${t.show k v}`") t.settings;
    in
    "| ${t.name} | `${t.file}` | ${lib.concatStringsSep ", " cells} |";

  # assertions は system の build 時にしか評価されないため、README と揃えて
  # 下限を割った変更も flake check で落ちるようにここで評価する。
  failedAssertions = map (a: a.message) (lib.filter (a: !a.assertion) hmConfig.assertions);

  expected =
    assert lib.assertMsg (failedAssertions == [ ])
      "Home Manager の assertions に失敗しました:\n- ${lib.concatStringsSep "\n- " failedAssertions}";
    pkgs.writeText "${marker}.md" (lib.concatLines ([
    "| Tool | File | Setting |"
    "| ---- | ---- | ------- |"
  ] ++ map row tools));
in
pkgs.runCommand "check-${marker}" { } ''
  # マーカー間を抜き出し、リスト内に置けるよう行頭の空白は無視して比較する。
  awk '/<!-- BEGIN generated: ${marker} -->/{f=1;next} /<!-- END generated: ${marker} -->/{f=0} f' \
    ${readme} | sed 's/^ *//' > actual

  if ! diff -u ${expected} actual; then
    echo
    echo "README.md の <!-- BEGIN generated: ${marker} --> ブロックが"
    echo "nix/home/programs/package-managers.nix の設定と一致しません。"
    echo "期待される内容:"
    cat ${expected}
    exit 1
  fi
  touch $out
''
