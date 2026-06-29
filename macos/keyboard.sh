#!/usr/bin/env bash
# Faster key repeat: hold a key and it repeats quickly with a short initial delay.
# Lower = faster. These go below the System Settings UI minimums
# (UI floors are InitialKeyRepeat 15 and KeyRepeat 2).
set -euo pipefail

defaults write -g InitialKeyRepeat -int 8    # delay before repeat kicks in (~120ms); UI floor is 15
defaults write -g KeyRepeat -int 1           # interval between repeats (~15ms); UI floor is 2

echo "Key repeat sped up (InitialKeyRepeat=8, KeyRepeat=1)."
echo "Log out and back in (or restart) for it to fully take effect."
