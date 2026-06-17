#!/usr/bin/env bash
# Deterministic so the read->check->protect->write protocol survives 1M-token sessions
# where a skill might not be recalled; non-blocking, injects checklist as additionalContext.

read -r -d '' MSG <<'EOF'
⚠️ NOTION WRITE GUARD — before sending this write, confirm ALL of the following:
1. READ: you re-fetched the page's CURRENT content this turn (not a stale/earlier copy).
2. MANUAL EDITS: you diffed against what you last wrote and are NOT overwriting Leonardo's
   manual changes (he edits in parallel during the session). If unsure, re-fetch and diff now.
3. COMMENT THREADS: this write does NOT delete or replace any text that anchors a comment
   thread. If you believe text genuinely must be removed/replaced and that would drop a
   comment thread → STOP, do not write. Tell Leonardo first: name the exact text + the thread,
   let him decide.
4. TARGETED EDIT: prefer update_content (old_str/new_str) over replace_content on any page
   that has his edits or comments.
If any item is unmet, do that step FIRST, then retry the write.
EOF

# Emit as PreToolUse additionalContext (non-blocking reminder injected into the model's context).
printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":%s}}' \
  "$(printf '%s' "$MSG" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')"
