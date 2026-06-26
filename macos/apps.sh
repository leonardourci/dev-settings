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

# GUI apps from healthy Homebrew casks. Plain-file configs are symlinked by each component's
# install.sh (zed/, cursor/). Loop's plist-based settings are versioned via loop/ (export/
# import). Raycast and macshot settings stay machine-local (plist/cloud, can't symlink).
#   caffeine = keep-awake | zed, cursor = editors | raycast = launcher
#   loop = window snapping | macshot = screenshots/recording
for cask in caffeine zed cursor raycast loop macshot; do
  if brew list --cask "$cask" &>/dev/null; then
    echo "    ok $cask (already installed)"
  else
    # --adopt: take over a pre-existing non-brew app instead of erroring out
    brew install --cask --adopt "$cask"
  fi
done
