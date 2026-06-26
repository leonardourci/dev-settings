# dev-settings

Personal dev environment config. Configs are symlinked into place (single source of truth),
apps install via Homebrew casks or bundled zips, plus a few dependencies.

## Structure

```
setup.sh          global bootstrap — runs every installer below
macos/keyboard.sh faster key repeat (InitialKeyRepeat/KeyRepeat)
macos/apps.sh     GUI apps via Homebrew cask (Caffeine, Zed, Cursor, Raycast, Loop, macshot)
terminal/         iTerm2 + zsh config (see terminal/README.md)
  install.sh      one-shot installer for both
  zsh/.zshrc      → ~/.zshrc  (symlinked)
  iterm2/         → iTerm2 prefs (custom-folder sync — auto-writes back here)
mousecapes/       Mousecape app (bundled zip) + .cape cursor themes
  install.sh      installs the app, adds capes to the library
vial/             Vial keyboard configurator (see vial/README.md)
  install.sh      installs Vial.app from the bundled zip
  *.vil           Sofle split-keyboard layout backup (loaded manually)
zed/              Zed config (see zed/README.md)
  install.sh      symlinks settings + keymap into ~/.config/zed/
  settings.json   → ~/.config/zed/settings.json  (symlinked)
  keymap.json     → ~/.config/zed/keymap.json    (symlinked)
cursor/           Cursor config (see cursor/README.md)
  install.sh      symlinks settings + keybindings into Cursor's User dir
  settings.json   → …/Cursor/User/settings.json     (symlinked)
  keybindings.json → …/Cursor/User/keybindings.json (symlinked)
vim/              minimal vim config (see vim/README.md)
  install.sh      symlinks vimrc into ~/.vimrc
  vimrc           → ~/.vimrc  (symlinked; system-clipboard sharing only)
loop/             Loop window-snapper settings (see loop/README.md)
  install.sh      defaults import → applies the snapshot
  export.sh       defaults export → re-snapshots after you change settings
  com.MrKai77.Loop.plist  exported settings (versioned in git, not symlinked)
.claude/          → ~/.claude/*  (Claude Code config — symlinked, see below)
CLAUDE.md         project rules (e.g. keep docs in sync with every change)
```

## Setup

### Everything at once

```bash
# Quit iTerm2 first (cmd+Q). Runs macOS tweaks, terminal, Claude, and Zed installers.
./setup.sh && source ~/.zshrc
```

`setup.sh` calls each component installer in order; all steps are idempotent, so it's safe
to re-run. Run an individual section below if you only want one part.

### macOS (key repeat + apps)

```bash
./macos/keyboard.sh   # fast key repeat; log out / restart to fully apply
./macos/apps.sh       # GUI cask apps: Caffeine (keep-awake), Zed, Cursor, Raycast, Loop, macshot
```

These apps keep settings in a `defaults` plist, not plain files, so they can't be symlinked.
**Loop** settings are still versioned in git via `loop/` (`defaults export`/`import` — see
[`loop/README.md`](loop/README.md)). **Raycast** (use its Cloud Sync) and **macshot** stay
machine-local. Loop is a window snapper (radial menu); macshot is a screenshot/recording tool.

### Terminal (iTerm2 + zsh)

```bash
# Quit iTerm2 first (cmd+Q). setup.sh installs Homebrew deps + both configs.
cd terminal && ./install.sh && source ~/.zshrc
```

Full details — shell features, fast tab completion, iTerm2 prefs sync — are in
[`terminal/README.md`](terminal/README.md).

### Zed

```bash
./zed/install.sh      # symlinks settings + keymap into ~/.config/zed/
```

Symlinked (single source of truth), so edits in the repo and in Zed are the same file. See
[`zed/README.md`](zed/README.md).

### Cursor

```bash
./cursor/install.sh   # symlinks settings + keybindings into Cursor's User dir
```

Symlinked like Zed. Seed config starts empty — customize in Cursor and it writes back here.
See [`cursor/README.md`](cursor/README.md) (incl. the Settings-UI symlink caveat).

### Vim

```bash
./vim/install.sh      # symlinks ~/.vimrc (system-clipboard sharing)
```

Minimal on purpose — just `set clipboard=unnamed` so yanks/pastes flow between vim and the
macOS clipboard. System `vim` already has `+clipboard`; no install needed. See
[`vim/README.md`](vim/README.md).

### Loop settings

```bash
./loop/install.sh     # applies the versioned Loop settings (defaults import)
```

Loop's config is a cfprefsd plist (can't be symlinked), so it's versioned via export/import
rather than a live link. After changing settings in Loop, run `./loop/export.sh` and commit
the updated plist. Keep Loop's iCloud sync **off** so git stays the source of truth. See
[`loop/README.md`](loop/README.md).

### Mousecape (cursor themes)

```bash
./mousecapes/install.sh
```

Installs `Mousecape.app` from the bundled zip (no Homebrew cask exists for it) and copies the
`.cape` themes into `~/Library/Application Support/Mousecape/capes/`. It does **not** apply a
cape — open Mousecape and Apply the one you want (or `mousecloak --apply <file>`), since that
changes your system cursors.

### Keyboard (Vial)

```bash
./vial/install.sh
```

Installs `Vial.app` from the bundled zip (the Homebrew cask is deprecated / fails Gatekeeper).
The `.vil` is a layout **backup**, not a live config — open Vial, plug in the keyboard, and
**File > Load** it to write the layout to the board. See [`vial/README.md`](vial/README.md).

## Claude Code config (`.claude/`)

`.claude/` is the source of truth for this machine's `~/.claude` config. Like `terminal/zsh`,
`zed/`, and `cursor/`, `.claude/` is **symlinked** — edits in either
place are the same file, so a new machine is just clone + run the installer.

### Install

```bash
# CLI (native installer, CLI only — no desktop app); the global ./setup.sh does this for you
curl -fsSL https://claude.ai/install.sh | bash
# config symlinks
bash .claude/install.sh
```

The global `./setup.sh` installs the CLI (only if missing) before symlinking config.
`.claude/install.sh` creates **per-item symlinks** from `~/.claude/<item>` into this repo. It deliberately does
**not** symlink all of `~/.claude` — that dir also holds runtime state and secrets
(`cache/`, `history.jsonl`, `sessions/`, `projects/`, `plugins/`, `mcp-needs-auth-cache.json`)
which must stay local and untracked. Existing real files are backed up to
`<file>.bak.<epoch>` before linking; the script is idempotent.

Symlinked items:

```
.claude/CLAUDE.md               → ~/.claude/CLAUDE.md
.claude/RTK.md                  → ~/.claude/RTK.md
.claude/statusline-command.sh   → ~/.claude/statusline-command.sh
.claude/hooks/notion-write-guard.sh  → ~/.claude/hooks/notion-write-guard.sh
.claude/hooks/git-workflow-guard.sh  → ~/.claude/hooks/git-workflow-guard.sh
.claude/hooks/compact-caveman.sh     → ~/.claude/hooks/compact-caveman.sh
.claude/hooks/human-readable-guard.sh → ~/.claude/hooks/human-readable-guard.sh
.claude/skills/create-pr/       → ~/.claude/skills/create-pr/
.claude/skills/human-readable/  → ~/.claude/skills/human-readable/
.claude/skills/create-ticket/   → ~/.claude/skills/create-ticket/
.claude/commands/commit.md      → ~/.claude/commands/commit.md
```

### Commit flow

`/commit` (`commands/commit.md`) dispatches a **subagent** that splits the working tree into a
handful of logical Conventional Commits (not one mega-commit) — keeping main-session context clean.
`hooks/git-workflow-guard.sh` is a non-blocking `PreToolUse(Bash)` nudge: on a `git commit` it
reminds the agent to use the `commit` skill (split by concern, no AI attribution); on a
`gh pr create` it reminds it to use the `create-pr` skill. No runtime deps.

`hooks/compact-caveman.sh` is a `PreCompact` hook (matchers `manual` + `auto`): on `/compact` and
on automatic context-fill compaction it injects instructions to write the summary in caveman-ultra
style while preserving all technical substance (hashes, paths, endpoints, decisions, errors
verbatim, failed approaches, task state). No runtime deps.

The `human-readable` skill captures how to write commits, PR bodies, and tickets for a human reader
(lead with what + why, plain language, no LLM-ese). It's referenced by the `commit` and `create-pr`
skills, and by `create-ticket` (which, for now, only ensures a ticket is human-readable).
`hooks/human-readable-guard.sh` is a `PreToolUse` nudge on Linear issue create/update that points
the agent at that skill. No runtime deps.

### `settings.json` is a sanitized template

This repo is **public**, so the tracked `.claude/settings.json` holds only personal/public
config (theme, hooks, statusline, public-marketplace plugins). Work-internal plugins and
permissions are **not** committed. The installer only seeds `settings.json` on a fresh
machine (never overwrites an existing live one) — merge by hand and re-enable private
plugins separately.

### Dependencies

- `statusline-command.sh` needs **`jq`** (`brew install jq`). Without it the status line is blank.
- The Notion write-guard hook has **no** runtime deps (emits pre-escaped JSON; no `python3`/`jq`).
- The `Bash` PreToolUse hook (`rtk hook claude`) needs **`rtk`** on `PATH` — see `RTK.md`.

### Not tracked here

Work/client-specific Claude tooling (insurance-portal analysis agents/skills, incident skill)
is intentionally excluded — it stays in `~/.claude` only and must not land in a public repo.
