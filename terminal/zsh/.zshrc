export NVM_DIR="$HOME/.nvm"
# put default node on PATH without sourcing nvm.sh (~0ms vs ~500ms)
# tracks `nvm alias default` automatically — no hardcoded version
() {
  local v=$(< "$NVM_DIR/alias/default") 2>/dev/null
  [[ -d "$NVM_DIR/versions/node/$v/bin" ]] || v=$(/bin/ls "$NVM_DIR/versions/node" 2>/dev/null | sort -V | tail -1)
  [[ -n "$v" ]] && export PATH="$NVM_DIR/versions/node/$v/bin:$PATH"
}
# lazy nvm: real nvm.sh sourced only on first nvm call (e.g. `nvm use`)
nvm() { unset -f nvm; \. "$NVM_DIR/nvm.sh"; nvm "$@"; }
export PATH="$HOME/.local/bin:$PATH"

command -v direnv >/dev/null && eval "$(direnv hook zsh)"

# completion — cached dump so tab is snappy; full rebuild only ~once/day
autoload -Uz compinit
_zdump="$HOME/.zcompdump"
# array-glob (NOT [[ -n …(#q…) ]], which never globs): Nmh-20 keeps the dump
# only if it exists and was modified <20h ago.
_zfresh=( "$_zdump"(Nmh-20) )
if (( $#_zfresh )); then
  compinit -C -d "$_zdump"   # dump fresh: skip security scan + rebuild (fast)
else
  compinit -d "$_zdump"      # stale/missing: rebuild once
fi
unset _zdump _zfresh
# case-insensitive matching only — dropped fuzzy 'r:|=*' partial match (slow on big sets)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# cache expensive completions (git remotes, brew, etc.)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zsh/cache"
[[ -d "$HOME/.zsh/cache" ]] || mkdir -p "$HOME/.zsh/cache"

# zsh plugins
# autosuggestions perf (set BEFORE sourcing): fetch suggestions in a background
# process and bind widgets once at load instead of on every prompt — this is what
# makes Tab/typing feel instant instead of laggy after the buffer changes.
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=80   # skip suggesting on very long lines
# which widgets accept the suggestion (must be set before source under MANUAL_REBIND)
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(forward-char end-of-line vi-forward-char vi-end-of-line)
# guarded sources: skip (no error) if the plugin isn't installed yet — keeps a fresh
# machine usable before `brew install`. ${HOMEBREW_PREFIX} covers Intel (/usr/local) too.
_brew_share="${HOMEBREW_PREFIX:-/opt/homebrew}/share"
[[ -r "$_brew_share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] \
  && source "$_brew_share/zsh-autosuggestions/zsh-autosuggestions.zsh"
# syntax-highlighting must be sourced LAST (it wraps all existing widgets)
[[ -r "$_brew_share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] \
  && source "$_brew_share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
unset _brew_share

# atuin — better Ctrl+R history search (fuzzy, shows cwd/exit/time).
# --disable-up-arrow keeps the normal Up arrow (previous-command) untouched.
# Guarded so the shell still loads if atuin isn't installed yet.
command -v atuin >/dev/null && eval "$(atuin init zsh --disable-up-arrow)"

# prompt — pure zsh, no deps (replaces starship)
autoload -Uz vcs_info add-zsh-hook
setopt prompt_subst

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' formats       ' %F{yellow} %b%f%c%u'
zstyle ':vcs_info:git:*' actionformats ' %F{yellow} %b%f|%a%c%u'
zstyle ':vcs_info:git:*' stagedstr     ' %F{red}+%f'
zstyle ':vcs_info:git:*' unstagedstr   ' %F{red}✎%f'

# untracked files + ahead/behind (no native vcs_info hook for these)
+vi-git-extras() {
  command git rev-parse --is-inside-work-tree &>/dev/null || return
  local -a flags
  command git status --porcelain 2>/dev/null | grep -q '^??' && flags+='%F{red}?%f'
  local ahead behind
  ahead=$(command git rev-list --count @{upstream}..HEAD 2>/dev/null)
  behind=$(command git rev-list --count HEAD..@{upstream} 2>/dev/null)
  (( ahead  )) && flags+="%F{red}⇡${ahead}%f"
  (( behind )) && flags+="%F{red}⇣${behind}%f"
  hook_com[unstaged]+="${(j::)flags}"
}
zstyle ':vcs_info:git*+set-message:*' hooks git-extras

add-zsh-hook precmd vcs_info

# directory (last 4 segments, cyan) + git + prompt char (green ok / red err)
PROMPT='%F{cyan}%(4~|…/%3~|%~)%f${vcs_info_msg_0_} %(?.%F{green}.%F{red})❯%f '

# treat /, -, = as word boundaries for Option+F partial accept
WORDCHARS="${WORDCHARS//[\/\-=]}"

# Option+Left/Right for word navigation
bindkey '\e[1;3C' forward-word   # Option+Right
bindkey '\e[1;3D' backward-word  # Option+Left
bindkey '\e\e[C'  forward-word   # Option+Right (alt sequence)
bindkey '\e\e[D'  backward-word  # Option+Left (alt sequence)

# autosuggestion accept with right arrow, falls back to cursor movement when no suggestion
# (the ACCEPT_WIDGETS list itself is set before the plugin source above — required by
# MANUAL_REBIND, which finalizes widget wrapping at source time)
bindkey '^[[C' forward-char
# machine-local env (AWS_PROFILE, work tokens, etc.) — not tracked; see ~/.zshrc.local
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
