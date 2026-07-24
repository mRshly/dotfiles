{ ... }:

{
  homebrew = {
    enable = true;

    # brew shellenv が fish_add_path --path で /opt/homebrew を PATH 先頭に
    # 強制配置し、nix プロファイルより優先されてしまうため無効化する。
    # 代わりに nix/home/programs/fish.nix で PATH 末尾に追加している。
    enableFishIntegration = false;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      # 宣言外の formula / cask / tap / masApps を switch のたびに
      # アンインストールする。手動で入れたものは次の switch で消えるため、
      # 残したいものは必ずこのファイルに追記すること。
      # App Store アプリも対象で、root 所有だと削除に失敗してエラーになる。
      cleanup = "uninstall";
    };

    taps = [
      {
        name = "d-kuro/tap";
        trusted = true;
      }
      {
        name = "dotenvx/brew";
        trusted = true;
      }
      {
        name = "k1low/tap";
        trusted = true;
      }
    ];

    # nixpkgs へ移せないものだけを brew で管理する。
    #   gcc  : nixpkgs 版は cc/ld/as など binutils 一式を提供し Xcode の
    #          ツールチェーンを上書きするため。brew 版は gcc-16 で衝突しない。
    #   make : brew 版は macOS 標準と衝突させない gmake として入る。
    #          nixpkgs 版は make を提供してしまう。
    #   mas  : nix-darwin の masApps が brew 版の mas を前提としている。
    #   podman  : nixpkgs は 5.8.4 でメジャー 1 つ古い。podman-compose と
    #          podman-tui は本体と API/CLI のバージョン整合が要るため、
    #          導入経路を podman 本体に揃えて brew のままにする。
    #   prek : nixpkgs は 0.4.4 で古い。
    #   dotenvx : nixpkgs は 2.3.2 で大幅に古い。
    #   mo   : nixpkgs の mo は Bash 用 mustache テンプレートエンジンで別物。
    #   gwq  : flake.lock が固定する nixpkgs (2026-07-02) にまだ無い。
    brews = [
      "gcc"
      "make"
      "mas"
      "podman"
      "podman-compose"
      "podman-tui"
      "prek"
      "d-kuro/tap/gwq"
      "dotenvx/brew/dotenvx"
      "k1low/tap/mo"
    ];

    casks = [
      "1password"
      "1password-cli"
      "alfred"
      "arduino-ide"
      "brave-browser"
      "cmux"
      "cursor"
      "discord"
      "display-pilot"
      "firefox"
      "font-hackgen"
      "font-hackgen-nerd"
      "font-intel-one-mono"
      "font-noto-color-emoji"
      "font-noto-emoji"
      "foobar2000"
      "ghostty"
      "google-chrome"
      "obsidian"
      "orbstack"
      "raycast"
      "rectangle"
      "spotify"
      "steam"
      "visual-studio-code"
      "vivaldi"
      "vlc"
      "wezterm"
      "zed"
      "zen"
    ];

    masApps = {
      "1Password for Safari" = 1569813296;
      "Bumpr" = 1166066070;
      "Deliveries" = 290986013;
      "GarageBand" = 682658836;
      "Goodnotes" = 1444383602;
      "iMovie" = 408981434;
      "Keynote" = 409183694;
      "Kindle" = 302584613;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "Reeder" = 6475002485;
      "Reeder Classic" = 1529448980;
      "RunCat" = 1429033973;
      "RunCatNeo" = 6757801838;
      "Save to Reader" = 1640236961;
      "The Unarchiver" = 425424353;
    };

  };
}
