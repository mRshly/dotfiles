{ ... }:

{
  homebrew = {
    enable = true;
    enableFishIntegration = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none";
    };

    taps = [
      {
        name = "d-kuro/tap";
        trusted = true;
      }
      {
        name = "dagger/tap";
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
      {
        name = "osx-cross/arm";
        trusted = true;
      }
      {
        name = "osx-cross/avr";
        trusted = true;
      }
    ];

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
      "claude"
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
      "Save to Reader" = 1640236961;
      "The Unarchiver" = 425424353;
    };

  };
}
