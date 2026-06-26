#!/usr/bin/env bash
# Install the Mousecape app (from the bundled zip) and add the repo's .cape themes
# to Mousecape's library. Does NOT apply a cape — pick one in the app (or via mousecloak),
# since applying changes your system cursors.
#
# Idempotent: skips the app if already installed; copying capes just refreshes them.

set -euo pipefail
shopt -s nullglob

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP="/Applications/Mousecape.app"
ZIP="$DIR/Mousecape-v1820.zip"
CAPES_DST="$HOME/Library/Application Support/Mousecape/capes"

echo "==> Mousecape app"
if [[ -d "$APP" ]]; then
  echo "    ok Mousecape already installed"
elif [[ -f "$ZIP" ]]; then
  TMP="$(mktemp -d)"
  unzip -oq "$ZIP" -d "$TMP"
  # zip lays out Applications/Mousecape.app
  cp -R "$TMP/Applications/Mousecape.app" /Applications/
  rm -rf "$TMP"
  # strip quarantine so Gatekeeper doesn't block first launch
  xattr -dr com.apple.quarantine "$APP" 2>/dev/null || true
  echo "    installed Mousecape -> $APP"
else
  echo "    ERROR: $ZIP missing — cannot install app." >&2
  exit 1
fi

echo "==> capes"
mkdir -p "$CAPES_DST"
count=0
for cape in "$DIR"/*.cape; do
  cp "$cape" "$CAPES_DST/"
  count=$((count + 1))
done
echo "    added $count cape(s) to $CAPES_DST"
echo "    open Mousecape and click a cape's Apply (or: mousecloak --apply <file>) to use it."
