#!/usr/bin/env bash
# PreToolUse(Bash) nudge: when a `git commit` is about to run, remind to split into logical
# commits and to omit AI attribution. Non-blocking — injects additionalContext only.
#
# No runtime deps: detects the commit via a tolerant grep on the raw hook input (no jq),
# and emits a pre-escaped static JSON string (no python3). Silent for any non-commit command.

input=$(cat)

# Fire only on `git commit` (also `git -C <path> commit`); ignore status/log/diff/etc.
if printf '%s' "$input" | grep -Eq 'git[[:space:]]+(-C[[:space:]]+[^[:space:]]+[[:space:]]+)?commit'; then
  printf '%s' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"⚠️ COMMIT GUARD — before this commit:\n1. SCOPE: are the staged changes ONE logical change? If they span unrelated concerns (feat+fix, code+docs, multiple independent modules), abort and split — stage each concern and commit it separately. Aim for a handful of focused commits, not one mega-commit (and not noisy over-fragmentation).\n2. SUBJECT: Conventional `type(scope): subject`, ≤50 chars, imperative, no trailing period.\n3. ATTRIBUTION: NO `Co-Authored-By: Claude` and NO \"Generated with Claude\" / any AI attribution — not in subject, body, or trailer."}}'
fi
