{ pkgs, ... }:

{
  home.packages = with pkgs; [
    asciinema
    atuin
    bat
    bat-extras.batdiff
    bat-extras.batgrep
    bat-extras.batman
    bat-extras.batpipe
    bat-extras.batwatch
    bat-extras.prettybat
    broot
    btop
    # Rust は stable のネイティブ開発のみのため rustup や rust-overlay は
    # 使わず nixpkgs 標準で揃える。rustc / cargo / clippy / rustfmt は
    # 同一リビジョン由来なのでバージョンが構造的に一致する。
    cargo
    ccusage
    chafa
    chezmoi
    clippy
    commitizen
    curl
    devbox
    difftastic
    eza
    fd
    fzf
    gemini-cli
    gh
    ghq
    gitleaks
    glow
    gnupg
    gwq
    lazydocker
    lazygit
    neovim
    # nodejs は npm / npx / corepack も提供する。pnpm と yarn-berry は
    # shebang で自前の nodejs を絶対指定するので PATH の node には依存
    # しないが、package.json の scripts が node を呼ぶため本体も入れる。
    nodejs
    pnpm
    ripgrep
    rust-analyzer
    rustc
    rustfmt
    uv
    wget
    yarn-berry
    zellij
  ];
}
