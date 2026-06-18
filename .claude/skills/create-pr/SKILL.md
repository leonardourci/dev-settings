---
name: create-pr
description: Open a draft PR for the current change — logical Conventional Commits (via the `commit` skill) with no AI attribution, optional isolated worktree off main, push, then a draft PR assigned to you with no reviewers (and a linked ticket if given). Use when asked to "open a PR", "create a draft PR", "ship this as a PR", or after finishing a change that should become a PR.
---

# Create a draft PR

Ships the current work as a **draft PR**, assigned to the user, with **no reviewers**. Defaults are
deliberate: drafts + no reviewers because the human reviews before requesting review.

All commands are portable — they discover the repo/host/tools at runtime. **Never hardcode an absolute
path** (no `/Users/<name>/...`); rely on `git`, `gh`, `@me`, and `command -v`.

## 0. Preconditions
- Only run when the user has asked for a PR (committing/pushing is outward-facing — confirm first if unsure).
- `gh auth status` must succeed. The repo is whatever `git rev-parse --show-toplevel` reports.

## 1. Branch / worktree (don't commit on the default branch)
- Find the default branch: `gh repo view --json defaultBranchRef -q .defaultBranchRef.name` (usually `main`).
- If currently on the default branch:
  - **Isolated worktree** (preferred when this repo provides the helper — check `command -v dev`):
    `dev worktree create <name>` (it bases off main), then inside the worktree
    `git checkout -b <branch>`. (`dev worktree create` names the branch `wt-<name>`; rename to the
    intended `<branch>` with `git checkout -b`.)
  - **Otherwise** branch in place: `git checkout -b <branch>`.
- Branch name: prefer the Linear-style `git checkout -b <ticket-branch>` if a ticket is given
  (the ticket's `gitBranchName`), else `<user-or-scope>/<short-desc>`.

## 2. Commit (via the `commit` skill)
- **Don't hand-write commits here.** Invoke the **`commit`** skill — it stages the intended changes and
  splits them into a handful of logical Conventional Commits (a single commit when the change is atomic),
  in a dispatched subagent, with no AI attribution. That keeps PR history reviewable and this skill's
  context clean.
- Limit scope by passing a path/scope hint as the skill's argument, so only the PR's files get committed
  (not unrelated working-tree changes).
- The `commit` skill never pushes/amends/rebases — Step 3 owns the push.
- Invariant the skill already enforces (restated so it never slips): commit as the user; **NEVER** a
  `Co-Authored-By: Claude` trailer or any "Generated with Claude Code" / AI-attribution line — not in any
  commit message, nor in the PR body written in Step 4.

## 3. Push
- `git push -u origin <branch>` (run from the worktree if you made one; or `git -C <worktree> push ...`).
- If a pre-push hook fails for an environment reason unrelated to the change (not a real failure),
  surface it; only bypass with `--no-verify` if the user agrees (CI is the real gate).

## 4. Draft PR
- Write the body to a tmp file (PR template structure if the repo has one). If a ticket is provided,
  start the body with `Closes <ticket-url>`.
- Create it — **draft, assignee `@me`, NO `--reviewer`**:
  ```
  gh pr create --draft --base "<default-branch>" --head "<branch>" \
    --title "<conventional title>" --body-file <tmpfile> --assignee @me
  ```
  Use `-R <owner>/<repo>` if not running inside the repo dir.
- Verify: `gh pr view <num> --json isDraft,assignees,reviewRequests,url` → confirm draft, you as
  assignee, reviewers empty. Report the URL.

## Notes
- Pair with a Linear ticket when one is expected: create/lookup the ticket first, link it in the body,
  and use its branch name. Do not post anything else to external systems unless asked.
- Keep PRs scoped to the change requested.
