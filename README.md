# Dotfiles

## How to manage my dotfiles

Managed by chezmoi, Nix flakes, nix-darwin, Home Manager, and Homebrew.

## First step

Clone this repository, then follow the [Nix workflow](#nix-workflow) below to install packages via nix-darwin/Home Manager. 

## Supported Platforms

- [x] MacOS
- [ ] Linux
- [ ] Windows

## Apply config

```bash
chezmoi apply
```

## RunCat Neo: Codex usage

Apply the Codex hook and converter with `chezmoi apply`. Restart Codex, open
`/hooks`, and trust the new user-level `Stop` hook when prompted.

After the first completed Codex turn creates `~/.codex/runcat-usage.json`, open
RunCat Neo settings and add that file as a Custom Metrics source named `Codex`.
This file-selection step grants RunCat Neo the required macOS sandbox access.

## Nix workflow

Two Apple Silicon hosts share the packages and Home Manager modules under `nix/darwin` and `nix/home`. Machine-specific settings stay under `nix/hosts`.

- `ShadowComet`: M1 MacBook Air (`shadowcomet`)
- `ShadowMercury`: M4 Mac mini (`shadowmercury`)

First-time nix-darwin install on ShadowMercury:

```bash
nix flake check
nix build .#darwinConfigurations.ShadowMercury.system
# Run the nix-darwin revision pinned in flake.lock, not the latest master,
# because this runs as root.
sudo nix run "github:nix-darwin/nix-darwin/$(jq -r '.nodes["nix-darwin"].locked.rev' flake.lock)#darwin-rebuild" -- switch --flake .#ShadowMercury
```

Daily build without activating:

```bash
nix flake check
darwin-rebuild build --flake ".#$(scutil --get LocalHostName)"
```

Activate after reviewing the build. System activation must run as root, so
`sudo` is required for `switch`:

```bash
sudo darwin-rebuild switch --flake ".#$(scutil --get LocalHostName)"
```


### Fish plugins (not yet in Nix)

Fish itself and its config are managed by Home Manager (`nix/home/programs/fish.nix`), but the [fisher](https://github.com/jorgebucaran/fisher) plugin manager and its plugins are not yet migrated and must still be installed manually:

```bash
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
fisher install jethrokuan/z patrickf1/fzf.fish edc/bass
```

## Homebrew

Homebrew is managed declaratively by the nix-darwin `homebrew` module in
`nix/darwin/homebrew.nix`, with `onActivation.cleanup = "uninstall"`.

Anything not declared there is uninstalled on every `darwin-rebuild switch`.
This covers formulae, casks, taps, and Mac App Store apps. A manual
`brew install` only survives until the next switch, so add it to
`nix/darwin/homebrew.nix` to keep it.

Packages live in Homebrew only when they cannot move to nixpkgs. The reason for
each one is recorded as a comment above the `brews` list.

## Per-project development environments

Global tools live in `nix/home/packages.nix`. Project-specific toolchains are
pinned inside each project with one of the following two options (mise and
other version managers are not used):

- **Nix flake** (`flake.nix` with a `devShells` output): enter with
  `nix develop`. Use this when the project already uses Nix or needs full
  control over the environment.
- **devbox** (`devbox.json`): enter with `devbox shell`, or run a command with
  `devbox run <script>`. Use this for a lighter setup or when non-Nix users
  and CI need the same environment. `devbox global` is not used.

## Security maintenance

Nix pins the toolchain (node, pnpm, yarn, uv, ...) with hashes and signed
binary caches. It does **not** protect the packages those tools download from
npm / PyPI, Homebrew, or code fetched at run time. Supply chain attacks
(malicious releases, compromised maintainer accounts, install-script worms)
mostly come in through those gaps.

### Daily

- **Build before switch, and review what changed.**

  ```bash
  darwin-rebuild build --flake ".#$(scutil --get LocalHostName)"
  nix store diff-closures /run/current-system ./result
  sudo darwin-rebuild switch --flake ".#$(scutil --get LocalHostName)"
  ```

  Unexpected new packages or version jumps are the signal to stop.
- **Review lockfile diffs before committing or installing.** This covers
  `flake.lock`, `devbox.lock`, `pnpm-lock.yaml`, `package-lock.json`,
  `yarn.lock` and `uv.lock`. Check that the sources are the expected
  repositories and registries, not forks or tarball URLs.
- **Install from the lockfile only:** `pnpm install --frozen-lockfile`,
  `npm ci`, `yarn install --immutable`, `uv sync --locked`. Add or upgrade a
  dependency as a separate, intentional step.
- **Do not run unpinned remote code.** Avoid `npx <pkg>`, `pnpm dlx`, `uvx`,
  `nix run github:owner/repo` and `curl ... | sh` without a pinned version or
  revision. Pin it (`npx pkg@1.2.3`, `github:owner/repo/<rev>`) when you need it.
- **Read before entering a cloned project.** `nix develop` runs `shellHook`;
  `devbox shell` runs `init_hook` and plugins. Read them first in repositories
  you do not own. Answer **no** when a flake asks to accept its `nixConfig`
  (extra substituters or trusted keys).

### Weekly

- Update this flake: `nix flake update`, then build, `diff-closures` and switch
  as above. Commit `flake.lock` separately so a bad update is easy to revert
  (`sudo darwin-rebuild --rollback` also works).
- Update each active project: `nix flake update` or `devbox update`, review and
  commit the lockfile. Old nixpkgs revisions keep unpatched CVEs.
- Homebrew is not pinned: run `brew outdated` and upgrade on purpose.
  Casks also update themselves.
- Check advisories for the projects you work on (`pnpm audit`, `npm audit`,
  GitHub Dependabot alerts).

### Rules to keep

- **Nix daemon:** keep `trusted-users = root`, `require-sigs = true` and only
  `cache.nixos.org` as substituter. Adding yourself to `trusted-users` is
  equivalent to root, because it lets any flake add caches and keys. Check
  `/etc/nix/nix.conf` on both hosts (ShadowMercury is managed by Determinate).
- **Package manager quarantine:** `nix/home/programs/package-managers.nix`
  makes the user configs skip releases younger than 7 days and keeps
  dependency install scripts disabled. Do not edit the generated files by hand.
  Build-time assertions reject values below this floor, and `nix flake check`
  fails when the table below differs from the Home Manager settings.

  <!-- BEGIN generated: package-manager-policy -->
  | Tool | File | Setting |
  | ---- | ---- | ------- |
  | npm | `~/.npmrc` | `ignore-scripts=true`, `min-release-age=7` |
  | pnpm | `~/.config/pnpm/config.yaml` | `minimumReleaseAge: 10080`, `strictDepBuilds: true` |
  | yarn | `~/.yarnrc.yml` | `enableScripts: false`, `npmMinimalAgeGate: 10080` |
  | uv | `~/.config/uv/uv.toml` | `exclude-newer = "7 days"` |
  <!-- END generated: package-manager-policy -->

  When an urgent security fix cannot wait, override it per project or per
  command (for example `pnpm-workspace.yaml` `minimumReleaseAgeExclude`,
  `npm install --min-release-age=0`, `uv lock --exclude-newer-package`).
  Allow a dependency's build script per project only after reading it
  (`pnpm approve-builds`, `dependenciesMeta` in yarn).

- **Homebrew taps** are arbitrary Ruby from GitHub. Add a third-party tap only
  when nixpkgs cannot provide the tool, and record why in
  `nix/darwin/homebrew.nix`.
- **Secrets:** run `prek install` after cloning so the gitleaks pre-commit hook
  is active. Keep tokens in 1Password / dotenvx, never in this repository.
- **Fisher** is installed by `curl | source` from `main`. Read the script
  first, or pin it to a release tag.

## Keyboardio Atreus

Keymaps and flashing scripts for my
[Keyboardio Atreus](https://shop.keyboard.io/products/keyboardio-atreus) live in
a separate repository: [mRshly/atreus-config](https://github.com/mRshly/atreus-config).

`nix/home/programs/fish.nix` exports `KALEIDOSCOPE_DIR`, which those scripts use
to locate [Kaleidoscope](https://github.com/keyboardio/Kaleidoscope).
