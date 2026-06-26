#!/usr/bin/env bash
# Install macOS GUI utility apps via Homebrew casks (healthy casks only — apps with
# deprecated/Gatekeeper-failing casks are bundled instead, see mousecapes/ and vial/).
# Idempotent: `brew install --cask` skips anything already installed.

set -euo pipefail

# Ensure brew is on PATH — login shells have it, but a bare script run may not.
if ! command -v brew >/dev/null; then
  for p in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [[ -x "$p" ]] && eval "$("$p" shellenv)" && break
  done
fi
if ! command -v brew >/dev/null; then
  echo "    SKIPPED: Homebrew not found. Install it (https://brew.sh), then re-run." >&2
  exit 0
fi

# GUI apps from healthy Homebrew casks. Their configs are symlinked separately by each
# component's install.sh (zed/, cursor/).
brew install --cask caffeine   # keep-awake menu-bar toggle
brew install --cask zed        # editor
brew install --cask cursor     # AI editor (VS Code fork)
