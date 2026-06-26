#!/usr/bin/env bash
# Point iTerm2 at this folder for prefs (load + auto-save).
# Run with iTerm2 QUIT. After running, open iTerm2 — settings load from repo.
# Idempotent: once iTerm2 is already syncing from this folder, re-runs are a no-op
# (no re-seed, no backup files) — safe to run any number of times.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLIST_SRC="$REPO_DIR/com.googlecode.iterm2.plist"
PLIST_DST="$HOME/Library/Preferences/com.googlecode.iterm2.plist"

if [[ ! -f "$PLIST_SRC" ]]; then
  echo "ERROR: $PLIST_SRC missing." >&2
  exit 1
fi

# Already pointed at this repo folder? Then iTerm2 is configured — nothing to do.
# (Checked before the "is iTerm running" guard, so a re-run with iTerm open is a safe no-op.)
if [[ "$(defaults read com.googlecode.iterm2 PrefsCustomFolder 2>/dev/null || true)" == "$REPO_DIR" \
   && "$(defaults read com.googlecode.iterm2 LoadPrefsFromCustomFolder 2>/dev/null || true)" == "1" ]]; then
  echo "    ok iTerm2 already syncing from this folder"
  exit 0
fi

if pgrep -x iTerm2 >/dev/null || pgrep -x iTerm >/dev/null; then
  echo "ERROR: iTerm2 is running. Quit iTerm2 first (cmd+Q), then re-run." >&2
  exit 1
fi

# First-time setup: back up an existing local plist only if it differs from the repo's
# (so we never pile up identical backups on re-runs), then seed the repo plist.
if [[ -f "$PLIST_DST" ]] && ! cmp -s "$PLIST_SRC" "$PLIST_DST"; then
  cp "$PLIST_DST" "$PLIST_DST.bak.$(date +%s)"
fi

# Flush cfprefsd FIRST so it doesn't overwrite our cp with stale cache
killall cfprefsd 2>/dev/null || true
sleep 1

# Copy repo plist into Preferences so first launch picks it up
cp "$PLIST_SRC" "$PLIST_DST"

# Flush again so cfprefsd reads fresh contents on next access
killall cfprefsd 2>/dev/null || true
sleep 1

# Tell iTerm2 to load + auto-save prefs from repo folder going forward
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$REPO_DIR"
# Save changes automatically (0 = save automatically; 1 = ask; 2 = never)
defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile_selection -int 0
defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile -bool true

# Final flush
killall cfprefsd 2>/dev/null || true

echo "OK. Open iTerm2. Prefs now sync with $REPO_DIR"
