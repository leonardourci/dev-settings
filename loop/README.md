# loop

Versioned settings for [Loop](https://github.com/MrKai77/Loop) (radial-menu window snapper).
The Loop **app** installs via `../macos/apps.sh` (Homebrew cask); this folder versions its
**settings** in git.

```
loop/
  com.MrKai77.Loop.plist   exported settings snapshot (committed, readable XML)
  install.sh               defaults import → applies the snapshot to this machine
  export.sh                defaults export → re-snapshots current settings into the repo
```

## Why export/import, not a symlink

Loop keeps its config in a cfprefsd-managed prefs plist (`~/Library/Preferences/
com.MrKai77.Loop.plist`). Symlinking that doesn't work: cfprefsd reads from an in-memory
cache and rewrites the file atomically, which replaces (breaks) the symlink on the first
settings change. iTerm avoids this with a built-in "custom prefs folder" feature; Loop has no
equivalent. So instead we version a `defaults export` and re-apply it with `defaults import` —
clean and reliable, at the cost of a manual re-export when settings change.

> Loop also offers iCloud sync. We use git here instead — keep Loop's **iCloud sync OFF** so
> the two don't fight over which is source of truth.

## Apply settings (new machine / restore)

```bash
./install.sh
```

Quits Loop if running, `defaults import`s the snapshot, flushes cfprefsd, relaunches Loop.
Also run by the global `../setup.sh`.

## Save settings after changing them

```bash
./export.sh        # re-snapshots into com.MrKai77.Loop.plist
git add loop/com.MrKai77.Loop.plist && git commit  # then push
```

Note: the snapshot includes a few machine-local odds and ends (menu-bar item position, a
usage counter) — harmless on import.
