#!/usr/bin/env bash

if hash xclip; then
  argumentorclipboard() {
    if [[ -n $* ]]; then
      # if arguments given, use those
      echo "$*";
    else
      # otherwise paste from X clipboard
      xclip -selection c -o
    fi
  }
fi
