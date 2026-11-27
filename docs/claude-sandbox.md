# Claude Code sandbox and deploy guard

English | [日本語](claude-sandbox.ja.md)

English is the primary version because agents read it; the Japanese
version is a translation for the human.

This document explains the `sandbox`, `permissions.ask` and `autoMode`
settings in `dot_claude/private_settings.json.tmpl`, and the Codex permission
profile that matches them. They serve two purposes:

- Herdr chief and worker sessions run under the sandbox without stopping on
  Herdr, Taskwarrior and Nix.
- No agent deploys to, or changes, an external service unless the human
  approves it.

The file is a chezmoi template so that it can write absolute paths under the
home directory (`{{ .chezmoi.homeDir }}`). Paths in it are absolute.
The `private_` prefix keeps the file at mode 0600, the mode Claude Code
creates it with, so other users cannot read the permission settings.

Some values came from the live file, because Claude Code had written them
there and they were in use: `model: "opus"` (an alias, so the newest Opus
is used without editing the file; a pinned ID would stay on one model),
the `codex`, `swift-lsp` and `lua-lsp` plugins,
`modelSettings.claude-opus-5-5.autoCompactWindow: "auto"` and
`allow: Bash(task *)`.

## What the sandbox allows

| Setting | Value | Why |
| --- | --- | --- |
| `network.allowUnixSockets` | `~/.config/herdr/herdr.sock` | `herdr agent list/get/start/prompt` talk to Herdr through this socket |
| `network.allowUnixSockets` | `/nix/var/nix/daemon-socket/socket`, `/private/var/run/nix-daemon.socket` | `nix develop` in workers. The first path is a symlink to the second. Both are listed because it is not confirmed which path the macOS sandbox checks |
| `filesystem.allowWrite` | `~/.local/share/task` | Taskwarrior database (the shared task board) |
| `filesystem.allowWrite` | `~/.cache/nix` | Nix evaluation and fetcher caches. Allowed instead of changing `XDG_CACHE_HOME`, which would move every tool's cache |
| `network.strictAllowlist` | `true` | Hosts outside `allowedDomains` are refused, even when the auto mode classifier would approve them |
| `network.allowedDomains` | see below | Read-only sources that development needs |
| `allowUnsandboxedCommands` | `true` | A command that fails in the sandbox can be retried outside it, after a human approval (see the next section) |

`allowedDomains`:

| Use | Hosts |
| --- | --- |
| GitHub (git remotes, flake inputs, uv Python downloads, apm) | `github.com`, `api.github.com`, `codeload.github.com`, `*.githubusercontent.com` |
| Nix substituters | `cache.nixos.org`, `install.determinate.systems` |
| npm, bun, pnpm | `registry.npmjs.org` |
| Python | `pypi.org`, `files.pythonhosted.org` |
| Rust | `crates.io`, `index.crates.io`, `static.crates.io` |
| Go | `proxy.golang.org`, `sum.golang.org` |

Some operations stay outside the sandbox on purpose, and always need a human
approval:

- Git commit signing and SSH through the 1Password agent
  (`~/.1password/agent.sock`). Allowing the socket would let any sandboxed
  command use the key, both for signing and for SSH authentication such as
  `git push`.
- `apm install`, which writes `~/.claude/skills` (protected settings) and
  `~/.apm`.

## The deploy guard

Deploys are not blocked by a list of CLI names. Three layers stop them
instead.

1. **Network allowlist** (`strictAllowlist` + `allowedDomains`). A sandboxed
   command cannot reach a cloud or SaaS API, because none is on the list.
2. **Unsandboxed retries go to the human**
   (`permissions.ask: Bash(dangerouslyDisableSandbox:true)`). In auto mode
   the classifier approves unsandboxed retries unless this rule exists. Ask
   rules resolve before the classifier, so no prompt text can talk past
   them. A `claude -p` run has no one to ask, so the retry is denied.
3. **Classifier rules** (`autoMode.soft_deny` "Remote Service Changes" and
   `autoMode.environment` "Herdr workers"). They tell the classifier that
   deploying, publishing or changing resources on any SaaS, PaaS or IaaS
   needs the human's explicit request, and that delegating it to another
   agent counts as doing it. The classifier reads `autoMode` only from user
   and managed settings, never from a repository's `.claude/settings*.json`.
   The rule covers every environment (staging and preview too) and
   changes to DNS, IAM, secrets and billing, not only deploys: a change
   left on an external service is hard to undo, and it can spread to costs
   and permissions.

Layers 1 and 2 are deterministic. Layer 3 is a judgment and narrows what
reaches layers 1 and 2; it is not a guarantee.

### Why Herdr needs layers 1 and 2

The classifier lifts a `soft_deny` block when the user's message describes
the exact action. A Herdr chief writes a worker's assignment into the
worker's user turn (`herdr agent start ... -- <prompt>`, `herdr agent
prompt`), so the worker sees the chief's text as the user's request. The
documentation does not say that the classifier tells the two apart. On the
chief's side, `Bash(herdr agent start *)` and `Bash(herdr agent prompt *)`
are allow rules, which resolve before the classifier, so the content of a
delegation is never reviewed there.

Claude Code's own subagents have their task description reviewed before
they start. Herdr workers are separate processes and get no such review.

A deploy that a chief asks for therefore stops at layer 1 (the host is not
allowed) and then at layer 2 (the unsandboxed retry needs a human).

### Why maintain destinations rather than tools

- **Failure direction.** A missing destination fails closed: the command
  stops and the human sees a prompt. A missing tool fails open: the deploy
  runs, and nobody notices until afterwards.
- **Size and growth.** Development needs few destinations, and the list
  changes slowly. Deploy paths are open-ended: new CLIs, `npx`/`bunx`
  wrappers, `make`/`just`/`npm run` scripts, and plain `curl` calls to an
  API.
- **Coverage.** The network check sits on the path every program takes,
  however it was started, and it does not depend on who wrote the prompt.

The earlier `deny: Bash(*deploy*)` rule shows the problem with matching
command text: it matched the whole command line, so it blocked
`herdr agent prompt` whenever the prompt mentioned a deploy, and it could
not be mirrored to Codex.

## Maintenance

When a sandboxed command fails because a host is not allowed:

1. Add the host to `allowedDomains` only if it is a read-only source, such
   as a package registry, a mirror or a cache.
2. Never add a cloud or SaaS API host (for example `*.googleapis.com`,
   `*.amazonaws.com`, `api.cloudflare.com`, `api.vercel.com`). Run those
   commands yourself with `!`, or approve the unsandboxed retry.
3. Edit `dot_claude/private_settings.json.tmpl`, update the table above and
   the Japanese version, then run `chezmoi apply`.

Claude Code rewrites `~/.claude/settings.json` while it runs. Before
applying, import keys that exist only in the live file into the source.

## Herdr workers

Workers that a chief starts for an assignment never leave the sandbox.
Approvals are not automated; the actions that would need one are taken
away from the worker. A command that fails in the sandbox comes back to the
worker as a failure, and the worker reports it instead of waiting for a
human. The loop needs no human approvals, and the sandbox and the deny
rules bound what it can do.

| | Sessions that talk to the human (chief and others) | Workers |
| --- | --- | --- |
| Run outside the sandbox | The human approves | Not possible. Returned as a failure |
| Human approvals | As before | None inside the loop |
| Limits | The three layers above | Sandbox and deny rules |

Start workers with these arguments (after `--` in `herdr agent start`):

| Kind | Arguments | Effect |
| --- | --- | --- |
| Codex | `-p worker` | Layers `~/.codex/worker.config.toml` (`approval_policy = "never"`) on top of `config.toml`. The `herdr-worker` permission profile still applies |
| Claude Code | `--settings '{"permissions":{"denyInsteadOfPrompting":true}}'` | A call that would wait on a permission prompt is denied instead, including `ask` rules and unsandboxed retries |

Work that has to leave the sandbox goes back to the chief and the human:

- **Commits.** Workers do not commit. Signing needs the 1Password agent,
  which the sandbox does not allow. The chief or the human reviews the
  worker's changes and makes signed commits.
- Pushes, deploys, and anything else that needs a host outside
  `allowedDomains`.

Checked on 2026-11-27 with a test worker of each kind:

| Step | Codex 0.172.0 (`-p worker`) | Claude Code (Haiku, `denyInsteadOfPrompting`) |
| --- | --- | --- |
| Effective setting | `/status`: `Profile herdr-worker (workspace with network access, never)` | — |
| `curl https://example.com` in the sandbox | Refused: not on the allowlist | Refused: not on the allow list |
| Same command outside the sandbox | Not possible: approval policy is `never` | Denied with no prompt |
| `npm install --dry-run` (an `ask` rule) | — | Denied with no prompt |
| `herdr agent list` | Works | Works |

With `-p`, Codex shows the startup warning "Running without the shared
background server: --profile requires embedded mode." It does not affect
the sandbox.

## Codex workers

`private_dot_codex/modify_private_config.toml` makes Codex use this
permission profile:

```toml
default_permissions = "herdr-worker"

[features]
network_proxy = true

[permissions.herdr-worker]
extends = ":workspace"

[permissions.herdr-worker.filesystem]
"<home>/.local/share/task" = "write"

[permissions.herdr-worker.network]
enabled = true

[permissions.herdr-worker.network.unix_sockets]
"<home>/.config/herdr/herdr.sock" = "allow"
```

- `extends = ":workspace"` is the profile form of the old
  `sandbox_mode = "workspace-write"`. A profile and the old `sandbox_mode` /
  `[sandbox_workspace_write]` keys cannot be combined: when `sandbox_mode`
  is present, Codex ignores the profile. The template removes the old keys.
- Codex allows Unix sockets through its network proxy, so the socket needs
  `features.network_proxy` and `network.enabled`. The profile lists no
  `domains`, so the proxy refuses every host and the sandbox stays offline.
  Claude's `allowedDomains` are not copied here: Codex workers already
  worked without network access, and `network_proxy` is experimental, so
  the profile relies on it only for the socket.
- `network_proxy` is `experimental` in codex-cli 0.172.0. If an update
  breaks it, the socket stops working and the network stays closed.
- The profile applies to every Codex session, the desktop app included.

Checked with codex-cli 0.172.0 and a throwaway `CODEX_HOME`
(`codex sandbox -P herdr-worker`):

| Settings | Herdr socket | Taskwarrior | Outbound |
| --- | --- | --- | --- |
| old `workspace-write` | denied | — | closed |
| profile with `unix_sockets` only | denied | works | closed |
| plus `features.network_proxy` | denied | — | closed |
| plus `network.enabled` (current) | works | works | proxy refuses `example.com` and `github.com` |

Codex has no equivalent of layer 2. With `approval_policy = "on-request"`
and `approvals_reviewer = "auto_review"`, a command that asks to run outside
the sandbox is approved by the reviewer, not by the human. Herdr workers
avoid this with `-p worker` (see [Herdr workers](#herdr-workers)); Codex
sessions started by hand still have it.

## Known gaps

- **Deploys through an allowed host.** `gh workflow run`, or a push to a
  branch that a hosting service deploys from, go through GitHub, which is
  allowed. Protect them on the GitHub side, for example with environment
  protection rules that require a reviewer. Git over SSH needs the
  1Password agent, so a sandboxed `git push` over SSH fails and needs a
  human approval.
- **Publishing to an allowed registry.** `npm publish` and the other
  `publish` commands are in `permissions.deny`.
- **Approving a prompt by habit.** Layer 2 shows the command. Read it
  before approving, especially in a worker pane.
- **Codex sessions started by hand.** A command that asks to run outside
  the sandbox is approved by Codex's auto review, not by the human. Herdr
  workers started with `-p worker` cannot ask at all.
- **Worker launch arguments live in the herdr-chief-of-staff skill**, not in
  this repository. If the chief starts a worker without them, the worker
  behaves like a session that talks to the human.

## Checking the setup

In a new Claude Code session after `chezmoi apply`:

- First prove that the sandbox is on: `touch ~/.sandbox-probe` must fail.
  If it succeeds, the session runs without the sandbox and every check below
  is meaningless (on 2026-11-27 an unsandboxed session reached
  `example.com` and almost passed for a broken allowlist). Turn it on with
  `/sandbox` and start again.
- `herdr agent list`, `task list` and `nix develop` work inside the sandbox.
- `curl -sI https://example.com` fails inside the sandbox (host not
  allowed). This also confirms that the `WebFetch` allow rule does not open
  every host.
- The unsandboxed retry of that command shows a permission prompt.

For Codex, run `codex sandbox -- herdr agent list` from a normal shell (a
sandbox cannot start inside another one). It should print the agent list.
