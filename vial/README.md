# vial

Vial configures the Sofle split keyboard (QMK/Vial firmware) over USB.

```
vial/
  install.sh                      installs Vial.app from the bundled zip
  Vial-v0.7.5.zip                 the app (bundled — see why below)
  SPLIT_KEYBOARD_SOFLE_VIAL.vil   layout backup (loaded manually, see below)
```

## Install

```bash
./install.sh
```

Unzips `Vial.app` into `/Applications` (idempotent; skips if already present) and strips the
quarantine attribute so Gatekeeper doesn't block first launch. Also run by the root
`../setup.sh`.

**Bundled, not Homebrew:** the `vial` cask is deprecated and fails the macOS Gatekeeper check
(Homebrew disables it 2026-09-01), so the app (v0.7.5, from the official
[vial-gui releases](https://github.com/vial-kb/vial-gui/releases)) is committed here instead.

## Applying the layout

The `.vil` is a **backup**, not a live config — Vial doesn't read it from disk. The actual
layout lives in the keyboard's onboard flash. To restore/apply it:

1. Open Vial and plug in the keyboard.
2. **File > Load** → pick `SPLIT_KEYBOARD_SOFLE_VIAL.vil`.

That writes the layout to the keyboard. (This is also why there's nothing to symlink.)

A browser alternative exists — [vial.rocks](https://vial.rocks) via WebHID in a Chromium
browser (Chrome/Edge/Brave/Arc, not Safari/Firefox) — same Load step, no install.
