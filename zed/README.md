# zed

Config for the [Zed](https://zed.dev) editor. The app installs via `../macos/apps.sh`
(Homebrew cask); this folder holds the config, symlinked into place.

```
zed/
  install.sh      symlinks the files below into ~/.config/zed/
  settings.json   → ~/.config/zed/settings.json  (symlinked)
  keymap.json     → ~/.config/zed/keymap.json    (symlinked)
```

## Install

```bash
./install.sh
```

Symlinks both files so edits in the repo and in Zed are the same file (single source of
truth). Idempotent; backs up an existing real file to `<file>.bak.<epoch>` before linking.
