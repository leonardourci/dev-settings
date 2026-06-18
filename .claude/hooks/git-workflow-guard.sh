#!/usr/bin/env bash
# PreToolUse(Bash) nudge for git/PR workflows: reminds the agent to route through the right
# skill (`commit` for commits, `create-pr` for PRs) and to keep history clean. Non-blocking —
# injects additionalContext only. No runtime deps (tolerant grep; pre-escaped static JSON).
# Silent for any unrelated command.

input=$(cat)

if printf '%s' "$input" | grep -Eq 'gh[[:space:]]+pr[[:space:]]+create'; then
  printf '%s' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"⚠️ PR GUARD — use the `create-pr` skill instead of hand-rolling this. It opens a DRAFT PR (assignee @me, NO reviewers), commits via the `commit` skill, and adds NO AI attribution in the message or the PR body. The PR body is read by a human — apply the `human-readable` skill (lead with what + why, plain language, call out risks). If you are already inside create-pr, carry on."}}'
elif printf '%s' "$input" | grep -Eq 'git[[:space:]]+(-C[[:space:]]+[^[:space:]]+[[:space:]]+)?commit'; then
  printf '%s' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"⚠️ COMMIT GUARD — prefer the `commit` skill (it stages and splits the work into logical Conventional Commits via a subagent) over hand-writing commits. Whatever the path: split unrelated concerns into separate commits (not one mega-commit, not noisy over-fragmentation); subject `type(scope): subject` ≤50 chars, imperative, no trailing period; write it for a human (apply the `human-readable` skill — lead with what + why, plain language); and NO `Co-Authored-By: Claude` / \"Generated with Claude\" attribution anywhere."}}'
elif printf '%s' "$input" | grep -Eq 'git[[:space:]]+(-C[[:space:]]+[^[:space:]]+[[:space:]]+)?add'; then
  printf '%s' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"⚠️ STAGING GUARD — before staging, plan the commits. Group the changes by logical concern and stage ONE concern at a time (explicit paths, not `git add -A`/`.` blindly), so each commit stays focused. If the work spans multiple concerns, prefer the `commit` skill — it plans the groups, stages, and commits them for you. Keep unrelated changes out of the same commit."}}'
fi
