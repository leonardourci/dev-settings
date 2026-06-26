#!/usr/bin/env bash
# Symlink Zed config into ~/.config/zed so edits in the repo and in Zed are the same file.
# The Zed app itself is installed via ../macos/apps.sh (Homebrew cask).
# Idempotent; an existing real file is backed up to <file>.bak.<epoch> before linking.

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="$HOME/.config/zed"
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

echo "==> Zed config"
link settings.json
link keymap.json
