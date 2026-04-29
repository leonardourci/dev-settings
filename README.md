# dev-settings

Personal dev environment config. Copy files to their destinations and install dependencies.

## Structure

```
zsh/
  .zshrc          → ~/.zshrc
  starship.toml   → ~/.config/starship.toml
zed/
  settings.json   → ~/.config/zed/settings.json
  keymap.json     → ~/.config/zed/keymap.json
SPLIT_KEYBOARD_SOFLE_VIAL.vil  → Vial app (split keyboard firmware layout)
```

## Setup

### Dependencies (macOS + Homebrew)

```bash
brew install starship zsh-autosuggestions zsh-syntax-highlighting direnv nvm shell-gpt
```

- **starship** — prompt (git branch, dir, status)
- **zsh-autosuggestions** — ghost-text suggestions from history
- **zsh-syntax-highlighting** — colors commands as you type
- **direnv** — per-directory env vars (used by devenv/nix projects)
- **nvm** — Node version manager
- **shell-gpt** — AI shell suggestions via `Ctrl+L` (requires local Ollama)

### Install

```bash
cp zsh/.zshrc ~/.zshrc
mkdir -p ~/.config && cp zsh/starship.toml ~/.config/starship.toml
cp zed/settings.json ~/.config/zed/settings.json
cp zed/keymap.json ~/.config/zed/keymap.json
source ~/.zshrc
```

## Shell features

| Feature | How |
|---|---|
| Right arrow accepts suggestion | zsh-autosuggestions + `forward-char` binding |
| Right arrow moves cursor when no suggestion | same binding falls through |
| Case-insensitive tab completion | `zstyle matcher-list` in `.zshrc` |
| `Ctrl+L` → AI command suggestion | shell-gpt widget, needs Ollama running locally |
| Git branch + status in prompt | starship |

## Ollama (for Ctrl+L AI suggestions)

Needs Ollama running locally with `qwen2.5-coder:1.5b` pulled:

```bash
brew install ollama
ollama pull qwen2.5-coder:1.5b
ollama serve
```

Without Ollama, `Ctrl+L` silently does nothing — rest of shell works fine.
