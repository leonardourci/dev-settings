#!/usr/bin/env bash
# Point iTerm2 at this folder for prefs (load + auto-save).
# Run with iTerm2 QUIT. After running, open iTerm2 — settings load from repo.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLIST_SRC="$REPO_DIR/com.googlecode.iterm2.plist"
PLIST_DST="$HOME/Library/Preferences/com.googlecode.iterm2.plist"

if pgrep -x iTerm2 >/dev/null || pgrep -x iTerm >/dev/null; then
  echo "ERROR: iTerm2 is running. Quit iTerm2 first (cmd+Q), then re-run." >&2
  exit 1
fi

if [[ ! -f "$PLIST_SRC" ]]; then
  echo "ERROR: $PLIST_SRC missing." >&2
  exit 1
fi

# Backup existing local plist
if [[ -f "$PLIST_DST" ]]; then
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
