#!/usr/bin/env bash
# One-shot terminal setup: zsh config + iTerm2 prefs.
# Safe to re-run. iTerm2 must be QUIT (cmd+Q) for the iTerm step to apply.

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> dependencies (Homebrew)"
if command -v brew >/dev/null; then
  # idempotent: brew skips anything already installed
  brew install zsh-autosuggestions zsh-syntax-highlighting direnv nvm jq atuin gh
else
  echo "    SKIPPED: Homebrew not found. Install it (https://brew.sh), then re-run."
fi

echo "==> zsh"
# Symlinked (like .claude/) so edits in the repo and ~/.zshrc are the same file.
# Idempotent; an existing real ~/.zshrc is backed up to ~/.zshrc.bak.<epoch>.
ZSHRC_SRC="$DIR/zsh/.zshrc"
ZSHRC_DST="$HOME/.zshrc"
if [[ -L "$ZSHRC_DST" && "$(readlink "$ZSHRC_DST")" == "$ZSHRC_SRC" ]]; then
  echo "    ok ~/.zshrc (already linked)"
else
  if [[ -e "$ZSHRC_DST" || -L "$ZSHRC_DST" ]]; then
    mv "$ZSHRC_DST" "$ZSHRC_DST.bak.$(date +%s)"
    echo "    backed up existing ~/.zshrc -> ~/.zshrc.bak.<epoch>"
  fi
  ln -s "$ZSHRC_SRC" "$ZSHRC_DST"
  echo "    linked ~/.zshrc -> $ZSHRC_SRC  (run: source ~/.zshrc)"
fi

echo "==> iTerm2"
if pgrep -x iTerm2 >/dev/null || pgrep -x iTerm >/dev/null; then
  echo "    SKIPPED: iTerm2 is running. Quit it (cmd+Q) and run: $DIR/iterm2/install.sh"
else
  bash "$DIR/iterm2/install.sh"
fi

echo "Done."
