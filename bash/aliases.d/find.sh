#!/usr/bin/env bash
# various find shorthands

# NOTE: quickly finding files and folders might be better served by fzf's ^T hotkey

# find directories
if iscommand fzf; then
  finddir() { find -type d 2>/dev/null | fzf --height 10 --query "$*"; }
else
  finddir() { find -type d 2>/dev/null -iname "*$**"; }
fi
