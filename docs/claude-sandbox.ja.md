# Claude Code のサンドボックスとデプロイの防止

[English](claude-sandbox.md) | 日本語

この文書は英語版の訳です。内容が食い違うときは英語版を正とします。英語版を主にしているのは、エージェントが英語で読むためです。

`dot_claude/private_settings.json.tmpl` の `sandbox`、`permissions.ask`、`autoMode` の設定と、それに対応する Codex の permission profile を説明します。目的は 2 つあります。

- Herdr の chief とワーカーのセッションを、Herdr、Taskwarrior、Nix で止まらずにサンドボックスの中で動かす。
- 人が承認しない限り、どのエージェントも外部のサービスへのデプロイや変更をしない。

このファイルを chezmoi のテンプレートにしているのは、ホームディレクトリの下の絶対パス（`{{ .chezmoi.homeDir }}`）を書くためです。ファイルの中のパスはすべて絶対パスです。名前に `private_` を付けて権限を 0600 に保っているのは、Claude Code がこのファイルを 0600 で作るのに合わせ、ほかのユーザーから権限の設定を読ませないためです。

いくつかの値は live のファイルから取り込みました。Claude Code がそこに書き込み、実際に使われていたためです。`model: "opus"`（別名なので、ファイルを直さなくても最新の Opus が使われる。固定の ID だと 1 つのモデルにとどまる）、プラグインの `codex`、`swift-lsp`、`lua-lsp`、`modelSettings.claude-opus-5-5.autoCompactWindow: "auto"`、`allow: Bash(task *)` です。

## サンドボックスで許可しているもの

| 設定 | 値 | 理由 |
| --- | --- | --- |
| `network.allowUnixSockets` | `~/.config/herdr/herdr.sock` | `herdr agent list/get/start/prompt` はこのソケットで Herdr と通信する |
| `network.allowUnixSockets` | `/nix/var/nix/daemon-socket/socket`、`/private/var/run/nix-daemon.socket` | ワーカーの `nix develop` のため。前者は後者へのシンボリックリンク。macOS のサンドボックスがどちらのパスで照合するかを確かめていないので、両方を書く |
| `filesystem.allowWrite` | `~/.local/share/task` | Taskwarrior のデータベース（共有のタスクボード） |
| `filesystem.allowWrite` | `~/.cache/nix` | Nix の評価とダウンロードのキャッシュ。`XDG_CACHE_HOME` を変えるとほかのツールのキャッシュの場所まで変わるので、書き込みの許可で対応する |
| `network.strictAllowlist` | `true` | `allowedDomains` にないホストへの接続は、自動モードの判定が認めても拒否する |
| `network.allowedDomains` | 下の表 | 開発に必要な、読み取り専用の取得先 |
| `allowUnsandboxedCommands` | `true` | サンドボックスで失敗したコマンドを、人の承認を経てサンドボックスの外で再実行できる（次の節を参照） |

`allowedDomains`:

| 用途 | ホスト |
| --- | --- |
| GitHub（git の remote、flake の入力、uv が取得する Python 本体、apm） | `github.com`、`api.github.com`、`codeload.github.com`、`*.githubusercontent.com` |
| Nix のキャッシュ | `cache.nixos.org`、`install.determinate.systems` |
| npm、bun、pnpm | `registry.npmjs.org` |
| Python | `pypi.org`、`files.pythonhosted.org` |
| Rust | `crates.io`、`index.crates.io`、`static.crates.io` |
| Go | `proxy.golang.org`、`sum.golang.org` |

次の操作は意図してサンドボックスの外に置いています。実行には必ず人の承認が要ります。

- 1Password のエージェント（`~/.1password/agent.sock`）を使う git の署名と SSH。ソケットを許可すると、サンドボックスの中のどのコマンドでもその鍵を使えるようになる。署名だけでなく、`git push` のような SSH の認証にも使える。
- `apm install`。設定保護の対象である `~/.claude/skills` と、`~/.apm` に書き込むため。

## デプロイを止める仕組み

デプロイは、CLI の名前の一覧では止めません。代わりに次の 3 層で止めます。

1. **ネットワークの許可リスト**（`strictAllowlist` と `allowedDomains`）。クラウドや SaaS の API は一覧にないので、サンドボックスの中のコマンドからは接続できない。
2. **サンドボックスの外での再実行は人に回す**（`permissions.ask: Bash(dangerouslyDisableSandbox:true)`）。このルールがないと、自動モードではサンドボックスの外での再実行を判定が許可してしまう。ask ルールは判定より先に照合されるので、プロンプトに何が書かれていても通り抜けられない。確認する相手のいない `claude -p` では、再実行は拒否される。
3. **判定に渡すルール**（`autoMode.soft_deny` の「Remote Service Changes」と、`autoMode.environment` の「Herdr workers」）。SaaS / PaaS / IaaS へのデプロイ、公開、リソースの変更には人の明示的な依頼が要ること、ほかのエージェントに頼むことも自分で実行するのと同じに扱うことを、判定に伝える。判定が `autoMode` を読むのはユーザー設定と管理設定だけで、リポジトリの `.claude/settings*.json` からは読まない。このルールは、デプロイだけでなく、すべての環境（staging と preview も）と、DNS、IAM、シークレット、課金設定の変更を対象にする。外部のサービスに残る変更は取り消しにくく、費用や権限に波及するため。

1 層目と 2 層目は、決まった規則で動く層です。3 層目は確率的な判断で、1 層目と 2 層目に届く操作を減らす役目を持ちます。3 層目だけでは保証になりません。

### Herdr で 1 層目と 2 層目が必要な理由

ユーザーの発言が操作そのものを具体的に述べていると、判定は `soft_deny` を解除します。Herdr の chief はワーカーへの課題を、ワーカーのユーザーの発言として書き込みます（`herdr agent start ... -- <プロンプト>`、`herdr agent prompt`）。そのため、ワーカーには chief の文面がユーザーの依頼に見えます。判定がこの 2 つを区別するとは、ドキュメントに書かれていません。chief の側では、`Bash(herdr agent start *)` と `Bash(herdr agent prompt *)` が allow ルールです。allow ルールは判定より先に照合されるので、委任の中身は chief の側で一度も確かめられません。

Claude Code 自身のサブエージェントは、起動する前に、渡された課題の説明を判定が確かめます。Herdr のワーカーは別のプロセスなので、この確認を受けません。

したがって、chief が頼んだデプロイは、まず 1 層目で止まります（ホストが許可されていない）。続いて 2 層目でも止まります（サンドボックスの外での再実行に人の承認が要る）。

### ツールではなく宛先を管理する理由

- **漏れたときに倒れる向き**: 宛先を入れ忘れると、コマンドが止まって人に確認が出る。ツールを入れ忘れると、デプロイが実行され、後になるまで誰も気づかない。
- **数と増え方**: 開発に必要な宛先は少なく、一覧はゆっくりしか変わらない。デプロイの経路は際限なく増える。新しい CLI、`npx`/`bunx` のようなラッパー、`make`/`just`/`npm run` のスクリプト、API を直接呼ぶ `curl` がある。
- **届く範囲**: ネットワークの確認は、どう起動されたプログラムでも必ず通る場所にある。誰がプロンプトを書いたかにも左右されない。

以前の `deny: Bash(*deploy*)` は、コマンドの文字列で照合する方式の問題をよく表しています。コマンド全体を部分一致で照合したため、プロンプトがデプロイに触れるだけで `herdr agent prompt` を止めていました。Codex に写すこともできませんでした。

## 運用の手順

ホストが許可されていないためにサンドボックスの中のコマンドが失敗したときの手順です。

1. `allowedDomains` に足すのは、パッケージのレジストリ、ミラー、キャッシュのような、読み取り専用の取得先だけにする。
2. クラウドや SaaS の API のホストは足さない（例: `*.googleapis.com`、`*.amazonaws.com`、`api.cloudflare.com`、`api.vercel.com`）。それらのコマンドは `!` を付けて自分で実行するか、サンドボックスの外での再実行を承認する。
3. `dot_claude/private_settings.json.tmpl` を編集する。上の表と英語版も直してから、`chezmoi apply` を実行する。

Claude Code は動いているあいだに `~/.claude/settings.json` を書き換えます。apply の前に、実ファイルにしかないキーをソースに取り込んでください。

## Herdr のワーカー

chief が課題のために起動したワーカーは、サンドボックスの外に出ません。承認を自動にするのではなく、承認が要る操作をワーカーから取り除きます。サンドボックスで失敗したコマンドは失敗としてワーカーに返り、ワーカーは人を待たずにそれを報告します。ループの中では人の承認が要らず、ワーカーにできることはサンドボックスと deny ルールが縛ります。

| | 人と話すセッション（chief など） | ワーカー |
| --- | --- | --- |
| サンドボックスの外での実行 | 人が承認する | できない。失敗として返る |
| 人の承認 | これまでどおり | ループの中では 0 |
| 歯止め | 上の 3 層 | サンドボックスと deny ルール |

ワーカーは次の引数で起動します（`herdr agent start` の `--` の後ろに書く）。

| 種類 | 引数 | 効果 |
| --- | --- | --- |
| Codex | `-p worker` | `config.toml` の上に `~/.codex/worker.config.toml`（`approval_policy = "never"`）を重ねる。permission profile の `herdr-worker` はそのまま効く |
| Claude Code | `--settings '{"permissions":{"denyInsteadOfPrompting":true}}'` | 許可の確認を待つことになる操作を、確認の代わりに拒否する。`ask` ルールとサンドボックスの外での再実行も含む |

サンドボックスの外に出る必要がある作業は、chief と人に戻します。

- **コミット**: ワーカーはコミットしない。署名には 1Password のエージェントが要り、サンドボックスはそれを許可していない。ワーカーの変更は chief か人が確かめ、署名してコミットする。
- push、デプロイ、そのほか `allowedDomains` にないホストが要る作業。

2026-11-27 に、それぞれの種類の試験用ワーカーで確かめた結果:

| 手順 | Codex 0.172.0（`-p worker`） | Claude Code（Haiku、`denyInsteadOfPrompting`） |
| --- | --- | --- |
| 実際に効いている設定 | `/status`: `Profile herdr-worker (workspace with network access, never)` | — |
| サンドボックスの中での `curl https://example.com` | 拒否（許可リストにない） | 拒否（許可リストにない） |
| 同じコマンドをサンドボックスの外で | できない（承認モードが `never`） | 確認なしで拒否 |
| `npm install --dry-run`（`ask` ルールに当たる） | — | 確認なしで拒否 |
| `herdr agent list` | 動く | 動く |

`-p` を付けると、Codex は起動時に「Running without the shared background server: --profile requires embedded mode.」という警告を出します。サンドボックスには影響しません。

## Codex のワーカー

`private_dot_codex/modify_private_config.toml` で、Codex に次の permission profile を使わせます。

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

- `extends = ":workspace"` は、以前の `sandbox_mode = "workspace-write"` を profile で書いたもの。profile と、以前の `sandbox_mode` / `[sandbox_workspace_write]` は併用できない。`sandbox_mode` があると、Codex は profile を無視する。そのため、テンプレートは以前のキーを取り除く。
- Codex は Unix ソケットの許可をネットワークのプロキシで扱う。そのため、ソケットを使うには `features.network_proxy` と `network.enabled` が要る。profile に `domains` を書いていないので、プロキシはすべてのホストを拒否し、サンドボックスはオフラインのままになる。Claude の `allowedDomains` はここに写さない。Codex のワーカーはこれまでも通信なしで作業できていたし、`network_proxy` は試験的な機能なので、頼るのはソケットの分だけにする。
- codex-cli 0.172.0 では、`network_proxy` は `experimental`。更新で壊れた場合は、ソケットが使えなくなるだけで、ネットワークは閉じたまま。
- この profile は、デスクトップアプリも含め、Codex のすべてのセッションに効く。

codex-cli 0.172.0 と一時的な `CODEX_HOME` で確かめた結果（`codex sandbox -P herdr-worker`）:

| 設定 | Herdr のソケット | Taskwarrior | 外向きの通信 |
| --- | --- | --- | --- |
| 以前の `workspace-write` | 拒否 | — | 閉じている |
| profile と `unix_sockets` だけ | 拒否 | 動く | 閉じている |
| `features.network_proxy` を足す | 拒否 | — | 閉じている |
| さらに `network.enabled` を足す（いまの設定） | 動く | 動く | プロキシが `example.com` と `github.com` を拒否 |

Codex には、2 層目に当たるものがありません。`approval_policy = "on-request"` と `approvals_reviewer = "auto_review"` の組み合わせでは、サンドボックスの外での実行を求めたコマンドを、人ではなく自動レビューが承認します。Herdr のワーカーは `-p worker` でこれを避けます（[Herdr のワーカー](#herdr-のワーカー)を参照）。手で起動した Codex のセッションには、この穴が残ります。

## 残っている穴

- **許可したホストを経由するデプロイ**: `gh workflow run` や、ホスティングサービスが自動でデプロイするブランチへの push は、許可している GitHub を通る。これは GitHub の側で止める（例: 承認者を必須にする environment の保護ルール）。SSH の git には 1Password のエージェントが要るので、サンドボックスの中で SSH の `git push` は失敗し、人の承認が要る。
- **許可したレジストリへの公開**: `npm publish` などの `publish` 系のコマンドは `permissions.deny` で止める。
- **習慣で承認してしまうこと**: 2 層目の確認にはコマンドが表示される。承認する前に読むこと。ワーカーのペインでは特に注意する。
- **手で起動した Codex のセッション**: サンドボックスの外での実行を求めたコマンドは、人ではなく Codex の自動レビューが承認する。`-p worker` で起動した Herdr のワーカーは、そもそも求められない。
- **ワーカーの起動の引数は herdr-chief-of-staff スキルにある**: このリポジトリにはない。chief が引数を付けずにワーカーを起動すると、そのワーカーは人と話すセッションと同じように動く。

## 設定の確認

`chezmoi apply` の後、新しい Claude Code のセッションで次を確かめます。

- 最初に、サンドボックスが有効なことを確かめる。`touch ~/.sandbox-probe` が失敗すればよい。成功した場合、そのセッションはサンドボックスなしで動いていて、以下の確認はどれも意味を持たない（2026-11-27 には、サンドボックスなしのセッションが `example.com` に接続でき、許可リストが壊れていると取り違えかけた）。`/sandbox` で有効にしてから、やり直す。
- `herdr agent list`、`task list`、`nix develop` がサンドボックスの中で動く。
- `curl -sI https://example.com` がサンドボックスの中で失敗する（許可されていないホスト）。これで、`WebFetch` の allow ルールがすべてのホストを開いていないことも確かめられる。
- そのコマンドをサンドボックスの外で再実行しようとすると、許可の確認が出る。

Codex は、通常のシェルで `codex sandbox -- herdr agent list` を実行して確かめる（サンドボックスの中で別のサンドボックスは起動できない）。エージェントの一覧が表示されればよい。
