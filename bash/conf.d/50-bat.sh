#!/usr/bin/env bash

# a few things that can use the colourful cat clone
if command -v bat >/dev/null; then

# manpage viewer
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

fi
