---
name: bootstrap-machine
description: One-shot setup of a fresh macOS machine from the dev-settings repo — runs ./setup.sh (the shell installers) then installs the Claude Code plugins a shell script can't (marketplaces + plugins read from .claude/settings.json). Personal config only; never touches work/private plugins. Use when asked to "set up this machine", "bootstrap", "set things up", "install everything", "new laptop", or /bootstrap-machine.
---

# Bootstrap machine

Sets up a fresh machine from this repo end to end. Two halves:

1. **`./setup.sh`** — everything a shell *can* do (macOS tweaks, terminal, Homebrew apps,
   the `claude` CLI, the `rtk` binary, config symlinks). Idempotent, safe to re-run.
2. **Claude Code plugins** — the part a shell script *can't* do. Marketplaces and plugins
   are managed by the `claude plugin` CLI, so they're installed here, **from inside Claude**.

This skill is **repo-derived**: the plugin list comes from the repo's own
`.claude/settings.json`, so it stays correct as you add/remove plugins — no second list to
maintain. The template is personal-only, so work/private plugins can never leak in.

Intended flow on a new machine: `git clone` this repo → open `claude` in the repo dir (yolo /
bypass-permissions mode) → "set up this machine".

## 0. Locate the repo (portable — never hardcode a path)

The repo root is the dir containing both `setup.sh` and `.claude/`. Resolve it, don't assume:

```bash
# If cwd is inside the repo:
ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
# Validate, else fall back to common locations, else ask the user:
[ -f "$ROOT/setup.sh" ] && [ -d "$ROOT/.claude" ] || ROOT=""
for d in "$HOME/projects/dev-settings" "$HOME/dev-settings" "$HOME/granted/dev-settings"; do
  [ -z "$ROOT" ] && [ -f "$d/setup.sh" ] && ROOT="$d"
done
echo "repo root: ${ROOT:-NOT FOUND — ask the user where they cloned dev-settings}"
```

Run every step below from `"$ROOT"`. If not found, ask the user for the path — never guess.

## 1. Run the shell bootstrap

```bash
cd "$ROOT" && ./setup.sh
```

- It chains every component installer in order and is idempotent.
- **Heads-up:** it may install Homebrew and could prompt for a `sudo`/Homebrew password or
  for Xcode Command Line Tools. Those prompts block — watch the run and let the user respond.
  Don't try to suppress them.
- If a step fails, stop and report which one. Do not proceed to plugins on a failed bootstrap
  (the `claude` CLI may not be installed yet).

After it finishes, `source ~/.zshrc` (or tell the user to open a fresh terminal).

## 2. Install Claude Code plugins (the gap setup.sh can't fill)

The source of truth is **the repo's** `.claude/settings.json`:
`extraKnownMarketplaces` (marketplace → GitHub repo) and `enabledPlugins` (`name@marketplace`).

Extract both with python3 (no jq dependency):

```bash
python3 - "$ROOT/.claude/settings.json" <<'PY'
import json, sys
cfg = json.load(open(sys.argv[1]))
# marketplace name -> "owner/repo" for the non-default marketplaces
mkts = cfg.get("extraKnownMarketplaces", {})
for name, spec in mkts.items():
    src = spec.get("source", {})
    if src.get("source") == "github":
        print(f"MARKET\t{name}\t{src['repo']}")
# enabled plugins (only the ones set true)
for key, on in cfg.get("enabledPlugins", {}).items():
    if on:
        print(f"PLUGIN\t{key}")
PY
```

Then:

1. **Add each `MARKET` marketplace** (idempotent — "already exists" is fine, ignore it):
   ```bash
   claude plugin marketplace add <owner/repo>
   ```
   `claude-plugins-official` is built-in (anthropics/claude-plugins-official) and usually
   already known; only `add` it if a later install complains it's missing.

2. **Install each `PLUGIN`** (`name@marketplace`):
   ```bash
   claude plugin install <name>@<marketplace>
   ```
   - **Skip and note any plugin whose `@marketplace` is not in the known set** (built-in
     `claude-plugins-official` + the `MARKET` list above). This is the safety net that keeps
     work/private plugins (e.g. anything `@medbillai`) out — they aren't in this template, so
     they won't appear, but skip-on-unknown guarantees it.
   - Plugin commands write config files; they take effect on the **next** Claude session.

Run installs sequentially and collect the result of each — don't abort the whole batch if one
plugin fails; record it and continue.

## 3. Verify

```bash
rtk --version          # the `rtk hook claude` Bash hook depends on this binary
claude plugin list     # confirm the plugins from step 2 are present
ls -la ~/.claude/CLAUDE.md ~/.claude/settings.json   # config symlinked / seeded
```

For a deeper machine-vs-repo audit (configs, casks, plist snapshots), hand off to
**`/sync-tools`** — don't re-implement that here.

## 4. Report

Tell the user concisely:
- ✅ what `setup.sh` installed (or where it failed),
- ✅ marketplaces added + plugins installed,
- ⏭️ any plugins skipped (and why — unknown/work marketplace),
- ▶️ **next step:** restart the terminal and **reopen `claude`** so the new plugins load.

Keep it to the outcome, not a transcript.
