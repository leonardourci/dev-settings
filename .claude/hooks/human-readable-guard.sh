#!/usr/bin/env bash
# PreToolUse nudge for ticket/issue creation (Linear save_issue/create_issue): reminds the
# agent that a HUMAN will read this and to use the `human-readable` skill. Non-blocking —
# injects additionalContext only. No runtime deps (pre-escaped static JSON).
#
# The settings matcher already scopes this to issue tools, so it fires unconditionally here.

printf '%s' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"⚠️ HUMAN-READABLE GUARD — a HUMAN teammate will read this ticket, not an LLM. Use the `human-readable` skill: lead with what changed and WHY it matters, plain language (no LLM throat-clearing, no marketing, no diff/log dumps), and include the context a teammate needs (repro steps / symptom / goal + acceptance criteria). Title concrete and specific."}}'
