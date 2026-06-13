# Mac Bootstrap — Design

**Date:** 2026-06-10
**Goal:** One-command setup of dev environment on a new Mac or new account, plus an ongoing maintenance skill. Replaces the manual copy instructions in README.

## Overview

Two deliverables:

1. **Bootstrap**: `Brewfile` + idempotent `setup.sh` in this repo. Works on a bare Mac (no Claude Code required). New machine flow: install Xcode CLT → clone repo → `./setup.sh`.
2. **Maintenance**: a `dev-doctor` Claude skill in this repo (`.claude/skills/dev-doctor/SKILL.md`) for post-bootstrap health checks, updates, and config-drift detection.

## Tool inventory and install method

| Tool | Method | Update path |
|---|---|---|
| git, gh, nvm, direnv, rustup, shell-gpt, zsh-autosuggestions, zsh-syntax-highlighting | `brew bundle` (Brewfile) | `brew upgrade` |
| iTerm2, Mousecape | Brewfile casks | `brew upgrade --cask` |
| Claude Code | `curl -fsSL https://claude.ai/install.sh \| bash` | self-updates |
| opencode | `curl -fsSL https://opencode.ai/install \| bash` | self-updates |
| gh-dash | `gh extension install dlvhdr/gh-dash` | `gh extension upgrade --all` |
| gh-review | `cargo install gh-review` (needs rustup stable) | rerun `cargo install` |
| Node | `nvm install --lts` | `nvm install --lts` |
| pnpm | `corepack enable pnpm` (after Node) | follows Node/corepack |
| Ollama | optional, `./setup.sh --with-ollama` (cask) | `brew upgrade --cask` |

Rationale: curl installers for Claude Code and opencode because their native installers self-update and brew casks lag. Everything else through brew for one-command upgrades.

## Repo layout (new files)

```
dev-settings/
  Brewfile
  setup.sh
  gh-dash/config.yml                    # gh-dash settings incl. R → gh-review keybinding
  .claude/skills/dev-doctor/SKILL.md
  docs/specs/2026-06-10-mac-bootstrap-design.md
  (existing: zsh/ zed/ nvim/ iterm2/ mousecapes/)
```

## Brewfile

```ruby
brew "git"
brew "gh"
brew "nvm"
brew "direnv"
brew "rustup"
brew "shell-gpt"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
cask "iterm2"
cask "mousecape"
```

## Config management: symlinks

Configs are **symlinked** from the repo into their live locations (replaces the README's copy approach). Edits to live configs show up immediately as git diffs in the repo.

| Repo path | Target |
|---|---|
| `zsh/.zshrc` | `~/.zshrc` |
| `zed/settings.json` | `~/.config/zed/settings.json` |
| `zed/keymap.json` | `~/.config/zed/keymap.json` |
| `nvim/` (directory) | `~/.config/nvim` |
| `gh-dash/config.yml` | `~/.config/gh-dash/config.yml` |

Exceptions (not symlinked):

- **iTerm2** — delegated to existing `iterm2/install.sh` (custom prefs-folder mechanism via `defaults write`).
- **Mousecape capes** — `*.cape` files copied to `~/Library/Application Support/Mousecape/capes/`. Apply attempted via `mousecloak` CLI if available; otherwise print reminder to apply in the Mousecape app. The bundled `Mousecape-v1820.zip` stays in the repo as a fallback but the cask is the canonical install.

Symlink behavior: if the target exists and is a real file/dir (not already the correct symlink), back it up to `<target>.bak` before linking. If already correctly linked, skip silently.

## setup.sh

Idempotent — every step checks before acting, safe to rerun anytime. Flags: `--with-ollama`.

Step order:

1. Homebrew: install if missing (official installer), `brew bundle --file Brewfile`.
2. Symlink configs per table above (with backup semantics).
3. iTerm2 prefs: run `iterm2/install.sh`.
4. Mousecape: copy capes, attempt `mousecloak` apply, else print manual reminder.
5. Node: source nvm, `nvm install --lts`, `corepack enable pnpm`.
6. Rust + gh-review: `rustup default stable` if no default toolchain, `cargo install gh-review` if binary missing.
7. Claude Code: curl installer if `claude` not on PATH.
8. opencode: curl installer if `opencode` not on PATH.
9. GitHub: `gh auth login` if `gh auth status` fails (interactive); `gh extension install dlvhdr/gh-dash` if missing.
10. Ollama (only with `--with-ollama`): cask install, pull the model referenced by the shell-gpt config.
11. Summary: print three lists — installed/linked this run, already present (skipped), needs manual action (e.g. apply cape, sign in to apps, restart terminal).

Error handling: steps run sequentially; a failing step prints a warning and continues (no `set -e` abort mid-bootstrap), failures collected into the summary. Network-dependent steps (curl installers, gh) check connectivity failure explicitly and report rather than half-install.

## gh-dash config (`gh-dash/config.yml`)

Minimal config containing the gh-review integration keybinding:

```yaml
keybindings:
  prs:
    - key: R
      name: review (gh-review)
      command: >
        gh-review {{.RepoName}} {{.PrNumber}}
```

Plus any default sections gh-dash needs. Flow: in gh-dash press `R` on a PR → gh-review TUI opens → `q` returns to gh-dash.

## dev-doctor skill

`.claude/skills/dev-doctor/SKILL.md` — invoked as `/dev-doctor` when working in this repo. Read-only diagnosis first, then offers fixes. Checks:

- All tools on PATH with versions (claude, opencode, gh, gh-dash extension, gh-review, node, pnpm, nvm, direnv).
- Symlinks intact — each target from the table still points into the repo (detects "app replaced symlink with real file" drift).
- `brew outdated` / `gh extension upgrade --all --dry-run`-style update availability.
- `gh auth status`.
- Node LTS current vs installed.
- Uncommitted drift in the repo (live config edits not yet committed).

Output: pass/fail table + proposed fix commands. Never auto-fixes without asking.

## README update

Rewrite Setup section: clone → `./setup.sh` (+ `--with-ollama` note). Document the gh-dash + gh-review review flow. Keep the shell-features table. Remove manual `cp`/`brew install` instructions.

## Testing

- `setup.sh` on the current (already-configured) machine: must be a near-no-op — everything reported as "already present", no broken configs. This validates idempotency.
- `bash -n setup.sh` + shellcheck for static validation.
- Symlink step tested by deleting one symlink and rerunning.
- Full bare-Mac path is validated for real on the next new machine/account; script logic keeps each step independently skippable so partial environments recover.

## Out of scope

- Vial keyboard layout (manual, needs the Vial app + hardware).
- Work environment (devenv/nix — covered by work's own skills).
- macOS system preferences automation.
- Secrets/credentials (sign-ins stay interactive: gh auth, Claude, opencode).
