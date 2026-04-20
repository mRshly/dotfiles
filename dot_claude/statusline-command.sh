#!/usr/bin/env bash
# Claude Code status line command
# Displays: cwd | git branch | model | context usage

input=$(cat)

# Current directory (show ~ for home)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
home="$HOME"
cwd="${cwd/#$home/\~}"

# Git branch (skip optional lock to avoid race conditions)
git_branch=""
if git -C "${cwd/#\~/$HOME}" --no-optional-locks branch --show-current 2>/dev/null | read -r branch; then
  [ -n "$branch" ] && git_branch=" $branch"
fi

# Model display name
model=$(echo "$input" | jq -r '.model.display_name // ""')

# Context usage
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used_pct" ]; then
  ctx_str=$(printf "ctx:%.0f%%" "$used_pct")
else
  ctx_str="ctx:--"
fi

# Rate limits (5h window if available)
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
rate_str=""
if [ -n "$five_pct" ]; then
  rate_str=$(printf " | 5h:%.0f%%" "$five_pct")
fi

# Build status line with ANSI colors suited for solarized_osaka_dark
# Using dimmed-friendly colors: cyan for path, yellow for branch, blue for model, green for context
printf "\033[36m%s\033[0m" "$cwd"
[ -n "$git_branch" ] && printf " \033[33m%s\033[0m" "$git_branch"
[ -n "$model" ] && printf " \033[34m| %s\033[0m" "$model"
printf " \033[32m| %s\033[0m" "$ctx_str"
[ -n "$rate_str" ] && printf "\033[32m%s\033[0m" "$rate_str"
