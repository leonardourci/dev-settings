# dev-settings

Personal dev environment config. Copy files to their destinations and install dependencies.

## Structure

```
zsh/
  .zshrc          → ~/.zshrc
zed/
  settings.json   → ~/.config/zed/settings.json
  keymap.json     → ~/.config/zed/keymap.json
.claude/          → ~/.claude/*  (Claude Code config — symlinked, see below)
SPLIT_KEYBOARD_SOFLE_VIAL.vil  → Vial app (split keyboard firmware layout)
```

## Setup

### Dependencies (macOS + Homebrew)

```bash
brew install zsh-autosuggestions zsh-syntax-highlighting direnv nvm shell-gpt
```

- **prompt** — pure zsh (`vcs_info`), no extra dependency
- **zsh-autosuggestions** — ghost-text suggestions from history
- **zsh-syntax-highlighting** — colors commands as you type
- **direnv** — per-directory env vars (used by devenv/nix projects)
- **nvm** — Node version manager
- **shell-gpt** — AI shell suggestions via `Ctrl+L` (requires local Ollama)

### Install

```bash
cp zsh/.zshrc ~/.zshrc
mkdir -p ~/.config && cp zed/settings.json ~/.config/zed/settings.json
cp zed/keymap.json ~/.config/zed/keymap.json
source ~/.zshrc
```

## Shell features

| Feature | How |
|---|---|
| Right arrow accepts suggestion | zsh-autosuggestions + `forward-char` binding |
| Right arrow moves cursor when no suggestion | same binding falls through |
| Case-insensitive tab completion | `zstyle matcher-list` in `.zshrc` |
| `Ctrl+L` → AI command suggestion | shell-gpt widget, needs Ollama running locally |
| Git branch + status in prompt | pure zsh `vcs_info` (`.zshrc`) |

## Ollama (for Ctrl+L AI suggestions)

Needs Ollama running locally with `qwen2.5-coder:1.5b` pulled:

```bash
brew install ollama
ollama pull qwen2.5-coder:1.5b
ollama serve
```

Without Ollama, `Ctrl+L` silently does nothing — rest of shell works fine.

## Claude Code config (`.claude/`)

`.claude/` is the source of truth for this machine's `~/.claude` config. Unlike the
rest of this repo (which is **copied**), `.claude/` is **symlinked** — edits in either
place are the same file, so a new machine is just clone + run the installer.

### Install

```bash
bash .claude/install.sh
```

Creates **per-item symlinks** from `~/.claude/<item>` into this repo. It deliberately does
**not** symlink all of `~/.claude` — that dir also holds runtime state and secrets
(`cache/`, `history.jsonl`, `sessions/`, `projects/`, `plugins/`, `mcp-needs-auth-cache.json`)
which must stay local and untracked. Existing real files are backed up to
`<file>.bak.<epoch>` before linking; the script is idempotent.

Symlinked items:

```
.claude/CLAUDE.md               → ~/.claude/CLAUDE.md
.claude/RTK.md                  → ~/.claude/RTK.md
.claude/statusline-command.sh   → ~/.claude/statusline-command.sh
.claude/hooks/notion-write-guard.sh → ~/.claude/hooks/notion-write-guard.sh
.claude/skills/create-pr/       → ~/.claude/skills/create-pr/
.claude/commands/commit.md      → ~/.claude/commands/commit.md
```

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
