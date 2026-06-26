#!/usr/bin/env bash
# Install the Vial app (from the bundled zip). Vial configures the Sofle split keyboard
# over USB. The .vil here is a layout BACKUP — Vial doesn't read a config file from disk
# (the layout lives in the keyboard's flash), so there's nothing to symlink. Load it
# manually in the app: File > Load, then it writes to the keyboard.
#
# Bundled instead of `brew install --cask vial` because that cask is deprecated and fails
# the macOS Gatekeeper check. Idempotent: skips if Vial is already installed.

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP="/Applications/Vial.app"
ZIP="$DIR/Vial-v0.7.5.zip"
VIL="$DIR/SPLIT_KEYBOARD_SOFLE_VIAL.vil"

echo "==> Vial app"
if [[ -d "$APP" ]]; then
  echo "    ok Vial already installed"
elif [[ -f "$ZIP" ]]; then
  TMP="$(mktemp -d)"
  unzip -oq "$ZIP" -d "$TMP"
  cp -R "$TMP/Vial.app" /Applications/
  rm -rf "$TMP"
  # strip quarantine so Gatekeeper doesn't block this un-notarized app on first launch
  xattr -dr com.apple.quarantine "$APP" 2>/dev/null || true
  echo "    installed Vial -> $APP"
else
  echo "    ERROR: $ZIP missing — cannot install Vial." >&2
  exit 1
fi

echo "    layout backup: $VIL"
echo "    to apply it: open Vial, plug in the keyboard, File > Load that .vil."
