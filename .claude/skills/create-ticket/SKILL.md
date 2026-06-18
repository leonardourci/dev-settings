---
name: create-ticket
description: Create a ticket / issue (e.g. Linear) written to be read by a human. For now this skill does ONE thing — ensure the ticket is human-readable; no branch, no PR, no auto-linking. Use when asked to "create a ticket", "open an issue", "file a ticket", or invokes /create-ticket.
---

# Create a ticket

Create a ticket/issue whose content is written for a **human** to read. Scope is intentionally
narrow for now: make it human-readable, nothing else (no branch creation, no PR, no auto-linking).

## Steps

1. **Invoke the `human-readable` skill** and apply it to the ticket you're about to write.
2. Write the ticket for a human:
   - **Title**: concrete and specific — the problem or the ask, not a vague label.
   - **Body**: lead with what + why. Include the context a teammate needs:
     repro steps (for a bug), the symptom/impact, or the goal + acceptance criteria (for a task).
   - No LLM throat-clearing, no diff/log dumps, no marketing language.
3. Create the ticket with the user's ticket tool (e.g. Linear `save_issue`). Ask which team/project
   if it isn't obvious.

## Out of scope (for now)

- No git branch, no PR, no commit.
- No automatic linking to other tickets/PRs.
- Keep it to creating one well-written, human-readable ticket.
