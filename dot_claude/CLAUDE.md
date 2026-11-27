# Tools

- Content search: Use `rg` (ripgrep) instead of `grep`
- File search: Use `fd` instead of `find`
- Git staging: name the paths (`git add <path>...`); never use `git add -A` or `git add .` (reason: both are denied in the settings, so a commit command that uses them stops an unattended run)
- Partial staging without `git add -p`: write the exact content you want
  staged into the index (`git hash-object -w <file>`, then
  `git update-index --cacheinfo 100644,<blob>,<path>`), then check both
  `git diff --cached` and `git diff` (reason: a `-U0` patch applied with
  `git apply --cached --unidiff-zero` put hunks in the wrong place)
- Reading diffs in scripts: use `git diff --no-ext-diff` (reason: an
  external diff tool is configured, and its side-by-side output breaks
  line-based parsing)
- Worktree-isolated sessions: run multi-step shell work as a script file
  that takes paths as arguments (reason: compound commands, `cd`, and
  `git -C` to the main checkout are refused when the harness cannot verify
  that they stay inside the worktree)

# Herdr coordination

When `HERDR_ENV=1`, use the `herdr-chief-of-staff` skill for human requests
to implement, fix, or review work. The human-facing agent is the persistent
chief of staff; delegate each implementation or review assignment to a fresh
Herdr agent in a new pane and a new conversation. Never select an existing
agent merely because it is idle or done, or resume a previous worker session.
An agent receiving a delegated assignment is a worker: execute that assignment
without becoming another chief of staff. Explicit human instructions override
this default. Outside Herdr, do not apply this workflow.
