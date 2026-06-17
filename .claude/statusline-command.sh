#!/usr/bin/env bash
# Claude Code status line: line 1: dir | branch  /  line 2: model | context bar
# ~/.claude/statusline-command.sh

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Claude"')

# Current directory: last 3 segments, replacing $HOME with ~
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
if [ -n "$cwd" ]; then
  cwd="${cwd/#$HOME/\~}"
  short_dir=$(echo "$cwd" | awk -F'/' '{
    n=NF; if(n<=3) print $0;
    else { out=""; for(i=n-2;i<=n;i++) out=out"/"$i; print "…"out }
  }')
else
  short_dir=""
fi

# Git branch from the cwd
raw_cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
if [ -n "$raw_cwd" ]; then
  branch=$(git -C "$raw_cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
fi

used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Build context progress bar (10 chars wide)
build_bar() {
  local pct="$1"
  local width=10
  local filled=$(echo "$pct $width" | awk '{printf "%d", ($1/100)*$2 + 0.5}')
  local empty=$(( width - filled ))
  local bar=""
  local i
  for (( i=0; i<filled; i++ )); do bar+="█"; done
  for (( i=0; i<empty; i++ )); do bar+="░"; done
  echo "$bar"
}

# Line 1: dir + branch
location=""
[ -n "$short_dir" ] && location="$short_dir"
[ -n "$branch" ] && location="$location  \033[0;35m$branch\033[0m"
printf "\033[0;34m%b\033[0m" "$location"

# Format token count with K suffix
format_tokens() {
  echo "$1" | awk '{
    if ($1 >= 1000) printf "%.1fK", $1/1000
    else printf "%d", $1
  }'
}

# Line 2: model | context bar | tokens used / total
printf "\n"
if [ -n "$used_pct" ]; then
  bar=$(build_bar "$used_pct")
  pct_display=$(printf "%.0f" "$used_pct")
  ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
  # Tokens currently in context (total_input_tokens is session-cumulative, incl. cache reads)
  used_tokens=$(echo "$input" | jq -r '.context_window.used_tokens // empty')
  if [ -z "$used_tokens" ]; then
    used_tokens=$(echo "$used_pct $ctx_size" | awk '{printf "%d", ($1/100)*$2}')
  fi
  used_fmt=$(format_tokens "$used_tokens")
  total_fmt=$(format_tokens "$ctx_size")
  printf "\033[0;36m%s\033[0m  %s %s%% (%s/%s)" \
    "$model" "$bar" "$pct_display" "$used_fmt" "$total_fmt"
else
  printf "\033[0;36m%s\033[0m" "$model"
fi
printf "\n"
