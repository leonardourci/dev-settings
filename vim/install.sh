#!/usr/bin/env bash
# Symlink the minimal vim config into ~/.vimrc so edits in the repo and in vim are the same
# file. Idempotent; backs up an existing real ~/.vimrc to ~/.vimrc.bak.<epoch> before linking.

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$DIR/vimrc"
DST="$HOME/.vimrc"

echo "==> vim config"
if [[ -L "$DST" && "$(readlink "$DST")" == "$SRC" ]]; then
  echo "    ok ~/.vimrc (already linked)"
else
  if [[ -e "$DST" || -L "$DST" ]]; then
    mv "$DST" "$DST.bak.$(date +%s)"
    echo "    backed up existing ~/.vimrc -> ~/.vimrc.bak.<epoch>"
  fi
  ln -s "$SRC" "$DST"
  echo "    linked ~/.vimrc -> $SRC"
fi
