#!/usr/bin/env bash
# Deterministic so the read->check->protect->write protocol survives 1M-token sessions
# where a skill might not be recalled; non-blocking, injects checklist as additionalContext.
#
# No runtime deps: additionalContext is emitted as a pre-escaped static JSON string
# (newlines -> \n), so there is no dependency on python3/jq for JSON encoding.

printf '%s' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"⚠️ NOTION WRITE GUARD — before sending this write, confirm ALL of the following:\n1. READ: you re-fetched the page'"'"'s CURRENT content this turn (not a stale/earlier copy).\n2. MANUAL EDITS: you diffed against what you last wrote and are NOT overwriting Leonardo'"'"'s\n   manual changes (he edits in parallel during the session). If unsure, re-fetch and diff now.\n3. COMMENT THREADS: this write does NOT delete or replace any text that anchors a comment\n   thread. If you believe text genuinely must be removed/replaced and that would drop a\n   comment thread → STOP, do not write. Tell Leonardo first: name the exact text + the thread,\n   let him decide.\n4. TARGETED EDIT: prefer update_content (old_str/new_str) over replace_content on any page\n   that has his edits or comments.\nIf any item is unmet, do that step FIRST, then retry the write."}}'
