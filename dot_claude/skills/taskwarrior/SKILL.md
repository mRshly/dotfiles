---
name: taskwarrior
description: "Shared task board (Taskwarrior 3, `task` CLI) for coding agents running in Herdr panes and the human who directs them. Use when the user asks to record, assign, claim, hand off, review or list tasks, when another agent hands you a task ID, or when you start or finish a unit of delegated work inside Herdr (HERDR_ENV=1). Do not use for the agent's own private step-by-step todo list."
---

# Taskwarrior board for Herdr agents

All agents and the human share one Taskwarrior database
(`~/.local/share/task`). The board is the source of truth for who is doing
what; Herdr messages only point at task IDs. Never write task lists into
ad-hoc Markdown files when the board can hold them.

## Identify yourself

Your assignee name is your Herdr agent name:

```bash
me=$(herdr agent get "$HERDR_PANE_ID" | jq -r '.result.agent.name // empty')
```

If `me` is empty you have no name. Ask the human to name you
(`herdr agent rename <pane> <name>`) instead of inventing one, because the
name must match what other agents use to address you. The human is
`agent:human`.

## Rules

- Always refer to tasks by UUID short form in messages to other agents
  (`task <id> _uuids` → first 8 chars). Numeric IDs are renumbered whenever any
  task is completed, so an ID read by another agent may point elsewhere.
- Use `rc.verbose=nothing` and `export` (JSON) when parsing output. Use the
  `board` report only for showing the human.
- `project` is the repository or work area (`project:worklog`), dotted for
  sub-areas (`project:worklog.ci`). Infer it from the git repo name of `cwd`.
- Keep descriptions to one imperative line. Put context, file paths, findings
  and decisions into annotations; they are the handoff record.
- Only modify tasks that are assigned to you or unassigned, except when the
  human tells you otherwise.

## Lifecycle

Read your queue:

```bash
task rc.verbose=nothing agent:"$me" status:pending export
task rc.verbose=nothing agent: status:pending -BLOCKED export   # unassigned and ready
```

Add a task (for yourself, another agent, or nobody):

```bash
task add project:worklog agent:py-support +review "Review lint config changes"
task add project:worklog depends:1a2b3c4d "Run integration tests after schema fix"
```

Claim and start work (start marks it active; only one active task per agent):

```bash
task <uuid> modify agent:"$me"
task <uuid> start
```

Record progress and findings as you go:

```bash
task <uuid> annotate "Root cause: actrun ignores matrix.include; see .github/workflows/ci.yml"
```

Finish:

```bash
task <uuid> annotate "Done: <what changed, where, how verified>"
task <uuid> done
```

Blocked by a question for the human:

```bash
task <uuid> stop
task <uuid> modify +question
task <uuid> annotate "Q: <the question>"
```

## Handoff to another agent

1. Create or reassign the task with `agent:<name>` and enough annotations that
   the receiver needs nothing else.
2. Tell the receiver through Herdr with the UUID only:

   ```bash
   herdr agent prompt <name> "Taskwarrior task 1a2b3c4d is assigned to you. Read it with: task 1a2b3c4d info"
   ```

3. Do not duplicate the task body in the prompt; the board is canonical.

When you receive such a message, run `task <uuid> info`, then claim and start
it as above.

## Tags

- `+review`: work is done and needs another agent or the human to review.
- `+question`: waiting on the human's answer.
- `+followup`: discovered while working on something else; not yet triaged.
