#!/usr/bin/env bash
# Apply versioned Loop settings into the live prefs domain.
#
# Loop stores its config in a cfprefsd-managed plist (~/Library/Preferences/
# com.MrKai77.Loop.plist). That can't be cleanly symlinked — cfprefsd reads from an
# in-memory cache and atomically rewrites the file, which would clobber a symlink. So we
# version an export of the domain here and `defaults import` it. Re-snapshot with ./export.sh
# after you change settings in Loop. (Keep Loop's iCloud sync OFF so git stays the source.)

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLIST="$DIR/com.MrKai77.Loop.plist"

echo "==> Loop settings"
if [[ ! -f "$PLIST" ]]; then
  echo "    no settings snapshot ($PLIST) — skipping"
  exit 0
fi

# Loop must be quit while we replace its prefs, or it overwrites them on exit.
was_running=0
if pgrep -x Loop >/dev/null; then
  was_running=1
  osascript -e 'tell application "Loop" to quit' 2>/dev/null || true
  pkill -x Loop 2>/dev/null || true
  sleep 1
fi

defaults import com.MrKai77.Loop "$PLIST"
killall cfprefsd 2>/dev/null || true   # flush cache so Loop reads the imported values

[[ "$was_running" == 1 ]] && open -a Loop
echo "    imported Loop settings from repo"
