# terminal

Terminal environment: **iTerm2** prefs + **zsh** config, versioned together for portability.

```
terminal/
  setup.sh                         one-shot installer (zsh + iTerm2)
  zsh/.zshrc                       → ~/.zshrc  (symlinked)
  iterm2/com.googlecode.iterm2.plist   iTerm2 prefs (auto-synced, see below)
  iterm2/install.sh                points iTerm2 at this folder
```

## Quick setup (new machine)

```bash
# Quit iTerm2 first (cmd+Q) so the iTerm step applies
./setup.sh
source ~/.zshrc
```

`setup.sh` does everything: installs the Homebrew deps below, **symlinks** `~/.zshrc` to
`zsh/.zshrc` (so edits in either place are the same file; an existing real `~/.zshrc` is
backed up to `~/.zshrc.bak.<epoch>`), and runs the iTerm2 installer. Re-runnable; if iTerm2
is open it skips the iTerm step and tells you the one command to finish. Needs
[Homebrew](https://brew.sh) on `PATH` (it skips the deps step and warns if missing).

## zsh

Machine-local / private env (`AWS_PROFILE`, work tokens, etc.) goes in `~/.zshrc.local`,
which `.zshrc` sources if present. Never tracked — keep secrets out of this repo.

### Dependencies (Homebrew)

- **zsh-autosuggestions** — ghost-text suggestions from history
- **zsh-syntax-highlighting** — colors commands as you type
- **direnv** — per-directory env vars (devenv/nix projects)
- **nvm** — Node version manager (lazy-loaded; near-zero startup cost)
- **atuin** — better `Ctrl+R` history search (fuzzy, shows cwd/exit/time)
- **gh** — GitHub CLI (PRs, issues, repo ops; the main git-forge tool agents reach for)
- prompt — pure zsh `vcs_info`, no extra dependency

### Shell features

| Feature | How |
|---|---|
| Fast tab completion | cached `compinit` dump (rebuilt ~once/day), case-insensitive matcher, completion cache |
| Right arrow accepts suggestion | zsh-autosuggestions + `forward-char` binding (falls through to cursor move when no suggestion) |
| `Ctrl+R` fuzzy history search | atuin (`--disable-up-arrow`, so Up arrow stays normal) |
| Git branch + status in prompt | pure zsh `vcs_info` |
| Option+←/→ word navigation | `bindkey` with `/ - =` as word boundaries |

### Tab completion is tuned for speed

`compinit` loads a cached dump and only does the slow security scan + rebuild when the dump
is older than ~20h, so opening a shell and pressing Tab is snappy. Matching is
case-insensitive only — the fuzzy partial-anywhere matcher (`r:|=*`) was removed because it
gets expensive on large completion sets (git refs, deep paths). Expensive completions are
cached under `~/.zsh/cache`. To restore fuzzy matching, add `'r:|=*'` back to the
`matcher-list` zstyle in `zsh/.zshrc`.

### atuin (Ctrl+R history)

`atuin` replaces `Ctrl+R` with a fuzzy, full-screen history search that records cwd, exit
code, duration, and time. Initialized with `--disable-up-arrow`, so the **Up arrow keeps its
normal behavior** (previous command) — atuin only owns `Ctrl+R`.

- Seed it from your existing shell history once: `atuin import auto`
- Cross-machine encrypted sync is **opt-in** and off by default — run `atuin register` /
  `atuin login` + `atuin sync` only if you want it.

## iTerm2

iTerm2 loads prefs from this folder (Settings → General → Preferences → "Load preferences
from a custom folder or URL"). With auto-save on, every GUI change writes back to
`iterm2/com.googlecode.iterm2.plist` here — commit the diff to share across machines.

`iterm2/install.sh` copies the plist into `~/Library/Preferences/`, then points iTerm2 at
this folder for future loads + auto-saves. **iTerm2 must be quit first.** It backs up any
existing local plist to `…plist.bak.<epoch>` (gitignored).

> If you move this folder, re-run `iterm2/install.sh` (or update `PrefsCustomFolder`) — the
> pointer stored in macOS prefs is an absolute path.

### Notable settings already configured

- **New tab/window inherits cwd**: `Custom Directory = Recycle` on all profiles
  ("Reuse previous session's directory").

### Manual prefs export (without install.sh)

```bash
cp ~/Library/Preferences/com.googlecode.iterm2.plist ./iterm2/com.googlecode.iterm2.plist
```
