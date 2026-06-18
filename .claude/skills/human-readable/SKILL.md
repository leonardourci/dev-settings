---
name: human-readable
description: Write commit messages, PR descriptions, and tickets/issues for a HUMAN reader — not an LLM and not a restatement of the diff. Use when composing any commit message, PR body, or ticket, or whenever output will be read by a teammate/reviewer. Invoked by the commit, create-pr, and create-ticket skills.
---

# Human-readable writing

The text you are about to write — a commit message, PR description, or ticket — is read by a
**human teammate**, not by an LLM and not by you later. Optimize for their understanding and time.

## Principles

- **Lead with the point.** First sentence = what changed and why it matters. A reviewer skimming
  the title + first line should understand the gist without reading further.
- **Explain the WHY, not the WHAT.** The diff already shows what changed. Spend words on motivation,
  the problem being solved, tradeoffs considered, and what you deliberately did *not* do.
- **Plain language.** No LLM throat-clearing ("This PR aims to…", "In this commit, we introduce…"),
  no marketing ("robust", "seamless", "comprehensive"), no emoji, no restating each file line-by-line.
- **Concrete over abstract.** Name the user-visible effect, the bug symptom, the error message, the
  ticket it closes. "Fixes the null cursor crash on empty result sets" beats "improves robustness".
- **Structure for skim.** Short summary first, then bullets/details. Long prose buried in a wall of
  text gets skipped.
- **Flag what the reader must act on.** Risks, breaking changes, follow-ups, things to verify, manual
  steps. Put these where they can't be missed.
- **Be honest.** Don't claim tests pass unless you ran them. Don't invent context. Say what's unknown
  or deferred.
- **Right-size it.** As short as possible while a teammate *with normal context* fully understands it.
  Don't pad to look thorough; don't compress out the context they need. Trim/Link raw logs and dumps
  instead of pasting them.

## Quick check before sending

1. Does the first line stand on its own?
2. Would a teammate know *why* this exists, not just *what* it does?
3. Any LLM-ese, filler, or diff-restating to cut?
4. Are risks / follow-ups / things-to-verify called out?
