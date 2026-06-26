#!/usr/bin/env bash
# Faster key repeat: hold a key and it repeats quickly with a short initial delay.
# Lower = faster. These go below the System Settings UI minimums
# (UI floors are InitialKeyRepeat 15 and KeyRepeat 2).
set -euo pipefail

defaults write -g InitialKeyRepeat -int 10   # delay before repeat kicks in (~150ms)
defaults write -g KeyRepeat -int 1           # interval between repeats (~15ms, very fast)

echo "Key repeat sped up (InitialKeyRepeat=10, KeyRepeat=1)."
echo "Log out and back in (or restart) for it to fully take effect."
