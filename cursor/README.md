# cursor

Config for [Cursor](https://cursor.com) (AI editor, VS Code fork). The app installs via
`../macos/apps.sh` (Homebrew cask); this folder holds the config, symlinked into place.

```
cursor/
  install.sh         symlinks the files below into ~/Library/Application Support/Cursor/User/
  settings.json      → …/Cursor/User/settings.json   (symlinked)
  keybindings.json   → …/Cursor/User/keybindings.json (symlinked)
```

## Install

```bash
./install.sh
```

Symlinks both files so edits in the repo and in Cursor are the same file (single source of
truth). Idempotent; backs up an existing real file before linking. The seed files start
empty (`{}` / `[]`) — customize in Cursor and the changes write back here to commit.

**Symlink caveat:** Cursor writes through these symlinks normally, but its Settings *UI*
can occasionally do an atomic save that replaces a symlink with a plain file. Editing
settings as JSON is always safe; if the link ever gets replaced, re-run `./install.sh`.
