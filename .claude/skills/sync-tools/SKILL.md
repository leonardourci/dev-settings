---
name: sync-tools
description: Audit this machine against the dev-settings repo and reconcile drift — installed apps/CLIs, symlinked configs, iTerm prefs pointer, and versioned app settings (e.g. Loop). Discovers what to check by SCANNING the repo (not a hardcoded list), so it stays current as components are added. Use when asked to "sync my tools", "check my setup", "what's out of sync", "/sync-tools", or after pulling repo changes on a machine.
---

# Sync tools

Compares the **live machine** to what the **dev-settings repo** expects, reports drift, and
(on confirmation) reconciles it. It is **repo-derived**: it learns the expected state by reading
the repo's own scripts, so new components are picked up automatically as long as they follow the
repo's conventions. Read-only by default — never mutate the machine or push without the user
saying so.

## 0. Locate the repo (portable — never hardcode a path)

The repo is wherever `~/.claude` is symlinked from. Resolve it:

```bash
REPO="$(cd "$(dirname "$(readlink ~/.claude/CLAUDE.md)")/.." && pwd)"   # <repo>/.claude/CLAUDE.md -> <repo>
```

If that fails (e.g. `.claude` not symlinked yet), fall back to asking the user or `git rev-parse`
from a known clone. Everything below is relative to `$REPO`.

## 1. Build the expected-state inventory BY READING THE REPO

Do not assume a fixed tool list — derive it each run so the skill never goes stale:

- **Cask GUI apps** — parse the cask list in `macos/apps.sh` (the `for cask in … ` line).
- **Homebrew CLIs** — parse the `brew install …` line(s) in `terminal/install.sh`.
- **Bundled apps** — any component dir with a `*.zip` + `install.sh` that copies a `.app` to
  `/Applications` (e.g. `mousecapes/`, `vial/`; also `aerospace/` if present). Read each
  `install.sh` to see the app name + destination.
- **Symlinked configs** — any `install.sh` that does `ln -s` (e.g. `zed/`, `cursor/`, and
  `.claude/install.sh`'s `ITEMS`). Note the source→target pairs.
- **iTerm prefs pointer** — `terminal/iterm2/install.sh` sets `PrefsCustomFolder`.
- **Versioned app settings** — any component with a `defaults export`/`import` pair (e.g.
  `loop/`): the repo holds a `*.plist` snapshot.
- **Claude CLI** — `setup.sh` installs it if missing.

Read `setup.sh` top-to-bottom first; it's the index of every component installer.

## 2. Probe the live machine for each

| Expected | Check |
|---|---|
| Cask app installed | `brew list --cask <name>` **or** the `.app` exists in `/Applications` |
| Homebrew CLI | `command -v <tool>` (or `brew list <formula>`) |
| Bundled app | `/Applications/<App>.app` exists |
| Symlink | `readlink <target>` equals the repo source (and the target resolves / isn't a stale real file) |
| iTerm pointer | `defaults read com.googlecode.iterm2 PrefsCustomFolder` == `$REPO/terminal/iterm2` |
| Versioned settings | `defaults export <domain> -` differs from the repo snapshot (ignore volatile keys — usage counters, `*__synchronizeTimestamp`, `NSStatusItem` positions — to avoid false drift) |
| Claude CLI | `command -v claude` or `~/.local/bin/claude` |

## 3. Report drift (read-only)

Print a compact table: `✅ in sync` / `⚠️ drifted` / `❌ missing|broken`, one row per item, grouped
by component. For versioned-settings drift, say **which direction** differs (live newer vs repo
newer) if determinable; otherwise just flag it for review. End with a one-line summary count.

## 4. Reconcile — only after the user confirms

Map each problem to the repo's **own** installer (don't reinvent the fix):

- Missing app / CLI / broken symlink / iTerm pointer → run that component's `install.sh`
  (or `./setup.sh` for a full pass — it's idempotent and safe to re-run).
- **Versioned settings drift needs a direction decision — always ask:**
  - keep the machine's version → run the component's `export.sh`, then the user commits;
  - keep the repo's version → run the component's `install.sh` (imports).
- Never `git commit`/`push` unless explicitly asked; if reconciling produced repo changes (e.g.
  a re-export), tell the user what to commit rather than committing for them.

## 5. Self-maintenance

This skill works as long as components follow the repo conventions (a folder with `install.sh`,
casks in `macos/apps.sh`'s list, the `.claude` `ITEMS` array, export/import pairs for plist
settings). If you encounter a component that does NOT fit those patterns and can't be discovered,
say so and update either the component (to follow convention) or this skill's step 1/2. The repo's
`CLAUDE.md` rule ("document every addition") keeps the scripts this skill reads accurate.
