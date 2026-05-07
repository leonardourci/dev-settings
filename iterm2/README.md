# iTerm2 settings

Versioned iTerm2 prefs for portability across machines.

## Install on a new machine

```bash
# iTerm2 must be quit first (cmd+Q)
./install.sh
```

Script copies the plist into `~/Library/Preferences/`, then points iTerm2 at this folder for future loads + auto-saves. Open iTerm2 — settings apply.

## How it works

iTerm2 supports loading prefs from a custom folder (Settings → General → Preferences → "Load preferences from a custom folder or URL"). With auto-save enabled, every change you make in the GUI writes back to `com.googlecode.iterm2.plist` in this folder. Commit the diff to share across machines.

## Notable settings already configured

- **New tab/window inherits cwd**: `Custom Directory = Recycle` on all profiles ("Reuse previous session's directory").

## Manual export (without install.sh)

```bash
cp ~/Library/Preferences/com.googlecode.iterm2.plist ./com.googlecode.iterm2.plist
```
