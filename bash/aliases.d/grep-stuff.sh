#!/usr/bin/env bash
# various grep shorthands
# NOTE: these are much better served by fzf
if iscommand fzf; then
  alias hh='history | fzf --tac ' # or configure ctrl-R in bash
  if iscommand bfs; then
    alias ff='bfs | fzf ' # or configure ctrl-T
  else
    alias ff='find . | fzf '
  fi
  if iscommand dpkg; then
    alias dpkgrep='dpkg --list | fzf '
  fi
else
  alias hh='history | grep -iE '
  alias ff='find . | grep -iE '
  alias dpkgrep='dpkg --list | grep -iE '
fi
