export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
export PATH="$HOME/.local/bin:$PATH"

eval "$(direnv hook zsh)"

# completion
autoload -Uz compinit && compinit
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

eval "$(starship init zsh)"

# autosuggestion accept with right arrow, falls back to cursor movement when no suggestion
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(forward-char end-of-line vi-forward-char vi-end-of-line)
bindkey '^[[C' forward-char
