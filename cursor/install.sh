#!/usr/bin/env bash
# Symlink Cursor config so edits in the repo and in Cursor are the same file.
# The Cursor app itself is installed via ../macos/apps.sh (Homebrew cask).
# Idempotent; an existing real file is backed up to <file>.bak.<epoch> before linking.
#
# Note: Cursor (VS Code fork) usually writes through these symlinks fine. If the Settings
# *UI* ever does an atomic save that replaces a symlink with a plain file, just re-run this.

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="$HOME/Library/Application Support/Cursor/User"
STAMP="$(date +%s)"
mkdir -p "$DEST"

link() {
  local name="$1" src="$DIR/$1" dst="$DEST/$1"
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    echo "    ok $name (already linked)"; return
  fi
  if [[ -e "$dst" || -L "$dst" ]]; then
    mv "$dst" "$dst.bak.$STAMP"; echo "    backed up $name -> $name.bak.$STAMP"
  fi
  ln -s "$src" "$dst"; echo "    linked $name"
}

echo "==> Cursor config"
link settings.json
link keybindings.json
