#!/usr/bin/env bash

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# unlimited history
# filesize is really not much of a concern here but I constantly lose old commands
HISTSIZE=-1
HISTFILESIZE=-1

# timestamp display for history file
HISTTIMEFORMAT="[%F %T] "

# append to the history file, don't overwrite it
shopt -s histappend

# save multiline commands in .. literally multiple lines
shopt -s lithist

# use hstr if available
if command -v hstr >/dev/null; then
  # bind to ctrl-r, use a space to ignore hstr command itself
  bind '"\C-r": "\C-a hstr -- \C-j"'
  # make it colorful
  export HSTR_CONFIG=hicolor
fi

# disable history expansion with !
set +H
