#!/usr/bin/env bash

# add ruby gem bin to $PATH if gem is installed
if command -v gem >/dev/null; then
  if GEMPATH=$(gem env path 2>/dev/null); then
    export PATH="$GEMPATH:$PATH"
  fi
fi
