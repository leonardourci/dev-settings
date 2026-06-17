---
description: Generate a Conventional Commit message for staged changes
argument-hint: [optional scope or note]
---

# Commit

Write Conventional Commit message for currently staged changes.

## Workflow

1. Run `git diff --cached` and `git status` (parallel) to see what's staged.
2. If nothing staged → tell user, stop.
3. Pick `type` + optional `scope` from rules below.
4. Write subject. Write body only if "why" is non-obvious from diff.
5. Show message to user. **Do not commit unless user confirms.**

## Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

## Rules

- Subject ≤ 50 chars, imperative mood ("add", not "added"/"adds"). No trailing period.
- Body wrapped at 72 chars. Explain **why**, not **what** — diff shows what.
- Skip body when intent obvious from subject.
- One logical change per commit. Flag drive-by refactors mixed in.
- No emojis. No `Co-Authored-By` unless user explicitly asks.
- Never use `--no-verify`, `--amend`, `-i` flags unless user asks.

## Types

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

## Scope

Use directory or module name (e.g., `auth`, `api`, `ui`). Optional. Project-specific scope list may live in `.claude/commands/commit.md` at project root — prefer project version when present.

## Examples

```
feat(auth): add refresh-token rotation on login

Prior tokens lived 7 days with no rotation, widening blast
radius if leaked. Rotate on every successful login.
```

```
fix(api): handle null pagination cursor

Cursor came back null on empty result sets, crashed iterator.
```

```
refactor(ui): extract button variants into shared component
```

## Anti-patterns

- ❌ `update code`
- ❌ `WIP`
- ❌ `fix bug` (which bug?)
- ❌ Mixing feature + refactor in one commit
- ❌ Long narrative subject; put narrative in body

$ARGUMENTS
