---
description: Stage and split current changes into logical Conventional Commits (via subagent)
argument-hint: [optional scope/note, or paths to limit to]
---

# Commit

Turn the current changes into a set of **logical Conventional Commits** — not one mega-commit,
not noisy over-fragmentation. The commit work runs in a **dispatched subagent** so it doesn't
burn main-session context.

## How to run this

1. Cheap pre-check in the main session: `git status --porcelain` + `git diff --stat`.
   If nothing to commit → tell the user, stop.
2. **Dispatch a subagent** (general-purpose) with the task prompt below. Forward `$ARGUMENTS`
   (scope hint or path filter) if given. Do NOT do the staging/committing inline.
3. Relay the subagent's summary (one line per commit). Do not push.

## Subagent task prompt

> Craft git commits for the current repo. Work only on the local working tree.
>
> 1. Inspect: `git status`, `git diff` (unstaged), `git diff --cached` (staged).
>    If `$ARGUMENTS` names paths, limit scope to those.
> 2. Group the changes into **logical commits** by concern:
>    - separate unrelated features/fixes from each other
>    - separate `refactor` (no behavior change) from `feat`/`fix`
>    - separate docs/config/tooling from code
>    - separate by package/module when the changes are independent
>    Target a handful — often **2–5**. Use **1** commit only when the change is genuinely atomic.
>    Don't fragment one logical change across commits; don't bundle unrelated changes together.
> Commit messages are read by humans — apply the `human-readable` skill: subject + body lead with
> what changed and WHY, in plain language, no LLM throat-clearing or diff-restating.
>
> 3. For each group, in dependency order:
>    - stage exactly that group with `git add <paths>` (use `git add -p <file>` only when a single
>      file truly holds two unrelated concerns)
>    - commit Conventional: `type(scope): subject` — subject ≤50 chars, imperative ("add" not
>      "added"), no trailing period
>    - add a body (wrapped at 72) only when the *why* isn't obvious from the diff
>    - **commit as the user. NO `Co-Authored-By: Claude`, NO "Generated with Claude" or any AI
>      attribution** — not in subject, body, or trailer
>    - use `git commit -F <tmpfile>` for multi-line messages
> 4. Never push, amend, rebase, or use `--no-verify`.
> 5. Return a terse summary: one line per commit (`<sha7> type(scope): subject`), plus any files
>    intentionally left unstaged and why.

## Conventional types

| Type | Use for |
|------|---------|
| `feat` | New user-visible feature |
| `fix` | Bug fix |
| `refactor` | Code change, no behavior change |
| `perf` | Performance improvement |
| `test` | Test-only changes |
| `docs` | Docs / README only |
| `build` | Build system, CI, project files |
| `chore` | Tooling, deps, housekeeping |
| `style` | Formatting, whitespace |

## Subject / scope rules

- ≤50 chars, imperative mood. No trailing period. No emojis.
- Body wrapped at 72; explain **why**, not **what** — the diff shows what.
- Scope = directory or module (`auth`, `api`, `ui`...). A project-local
  `.claude/commands/commit.md` scope list wins when present.

## Anti-patterns

- ❌ one commit for many unrelated changes (the thing this skill exists to prevent)
- ❌ over-splitting one logical change into many tiny commits
- ❌ `update code`, `WIP`, `fix bug` (which bug?)
- ❌ mixing `feat` + `refactor` in one commit
- ❌ AI attribution anywhere

$ARGUMENTS
