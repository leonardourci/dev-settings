#!/usr/bin/env bash
# Snapshot the current live Loop settings back into the repo. Run this after changing
# settings in Loop, then commit the updated plist. (This is the manual "sync back" step —
# the trade-off for versioning in git instead of a live symlink.)

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLIST="$DIR/com.MrKai77.Loop.plist"

defaults export com.MrKai77.Loop "$PLIST"
plutil -convert xml1 "$PLIST"   # readable XML so git diffs are meaningful
echo "exported Loop settings -> $PLIST"
echo "review & commit: git add loop/com.MrKai77.Loop.plist"
