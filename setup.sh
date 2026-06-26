#!/usr/bin/env bash
# Global bootstrap: runs every component installer in this repo, in order.
# Safe to re-run — each step is idempotent. Quit iTerm2 (cmd+Q) first so its prefs apply.

set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> macOS system tweaks"
bash "$DIR/macos/keyboard.sh"

echo "==> macOS apps (Caffeine)"
bash "$DIR/macos/apps.sh"

echo "==> terminal (zsh + iTerm2 + Homebrew deps)"
bash "$DIR/terminal/install.sh"

echo "==> Claude Code (CLI + config)"
# Install the CLI via the native installer (CLI only, no desktop app) if absent.
# Check both PATH and the known install path, since this script may run before
# ~/.local/bin is on PATH. Installs to ~/.local/bin/claude.
if command -v claude >/dev/null || [[ -x "$HOME/.local/bin/claude" ]]; then
  echo "    ok claude CLI already installed"
else
  echo "    installing Claude Code CLI..."
  curl -fsSL https://claude.ai/install.sh | bash
fi
bash "$DIR/.claude/install.sh"

# These component scripts print their own "==>" headers.
bash "$DIR/mousecapes/install.sh"
bash "$DIR/vial/install.sh"
bash "$DIR/zed/install.sh"
bash "$DIR/cursor/install.sh"

echo "All done. Open a fresh terminal; restart/log out for key-repeat to fully apply."
