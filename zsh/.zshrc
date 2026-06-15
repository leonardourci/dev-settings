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

eval "$(direnv hook zsh)"

# completion
autoload -Uz compinit && compinit -u
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*'

# zsh plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# shell-gpt / Ollama AI completions
export SGPT_MODEL="ollama/qwen2.5-coder:1.5b"
export OPENAI_API_KEY="ollama"
export OPENAI_API_BASE="http://localhost:11434/v1"

# Ctrl+L → AI shell suggestion via sgpt
_sgpt_zsh() {
  if [[ -n "$BUFFER" ]]; then
    _sgpt_prev_cmd=$BUFFER
    BUFFER+=" "
    zle -R
    BUFFER=$(sgpt --shell --no-interaction "$_sgpt_prev_cmd" 2>/dev/null)
    zle end-of-line
  fi
}
zle -N _sgpt_zsh
bindkey '^l' _sgpt_zsh

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
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(forward-char end-of-line vi-forward-char vi-end-of-line)
bindkey '^[[C' forward-char
export AWS_PROFILE="granted-adm-leonardo-urci"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/leonardoguimaraesurci/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
