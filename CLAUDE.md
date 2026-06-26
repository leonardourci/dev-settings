# dev-settings — project instructions

Portable macOS dev-environment config: each component lives in its own folder with an
installer, and the root `setup.sh` chains them (idempotent, safe to re-run).

## Rules

- **Document every addition in the same change.** When you add or change a component
  (a new tool, install step, config, script, or dependency), update the docs as part of
  that same change — never defer it:
  - the component's own README if it has one (e.g. `terminal/README.md`), and
  - the root `README.md`: its Structure list and the matching Setup section.
- **Keep it runnable from `./setup.sh`.** Any new installer script must be wired into the
  root `setup.sh`, and every step must stay idempotent.

`.claude/CLAUDE.md` in this repo is the user's GLOBAL Claude config (symlinked to
`~/.claude`); repo-specific rules belong in THIS file, not there.
