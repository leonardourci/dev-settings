#!/usr/bin/env bash
# Symlink this repo's .claude config into ~/.claude so a single clone restores the setup.
#
# Per-item symlinks (NOT a whole-dir link): runtime state in ~/.claude
# (cache/, history.jsonl, sessions/, projects/, plugins/, secrets) is left untouched.
#
# Idempotent. Existing real files are backed up to <file>.bak.<epoch> before linking.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"   # repo .claude dir
DEST="$HOME/.claude"
STAMP="$(date +%s)"

mkdir -p "$DEST/hooks" "$DEST/skills" "$DEST/commands"

# Items symlinked into ~/.claude. settings.json is handled separately (see below).
ITEMS=(
  "CLAUDE.md"
  "RTK.md"
  "statusline-command.sh"
  "hooks/notion-write-guard.sh"
  "hooks/git-workflow-guard.sh"
  "skills/create-pr"
  "commands/commit.md"
)

link() {
  local rel="$1" src="$SRC/$1" dst="$DEST/$1"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "ok   $rel (already linked)"; return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mv "$dst" "$dst.bak.$STAMP"
    echo "back $rel -> $rel.bak.$STAMP"
  fi
  ln -s "$src" "$dst"
  echo "link $rel"
}

for item in "${ITEMS[@]}"; do link "$item"; done

# settings.json: repo ships a SANITIZED personal template (no work/private plugins).
# Only seed it on a fresh machine; never clobber an existing live settings.json.
if [ -e "$DEST/settings.json" ] || [ -L "$DEST/settings.json" ]; then
  echo "skip settings.json (exists — repo copy is a template; merge by hand if wanted)"
else
  cp "$SRC/settings.json" "$DEST/settings.json"
  echo "copy settings.json (from template)"
fi

echo "done."
