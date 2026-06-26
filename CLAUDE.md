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
- **Keep components discoverable by `/sync-tools`.** That skill audits a machine against this
  repo by *scanning* it (the `setup.sh` chain, each component's `install.sh`, the cask list in
  `macos/apps.sh`, `.claude` `ITEMS`, and `defaults export`/`import` plist snapshots). Follow
  those conventions so new components are picked up automatically; if one genuinely can't, update
  the `sync-tools` skill in the same change.

`.claude/CLAUDE.md` in this repo is the user's GLOBAL Claude config (symlinked to
`~/.claude`); repo-specific rules belong in THIS file, not there.
