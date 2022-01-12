#!/usr/bin/env bash
# read markdown files
if iscommand pandoc; then
  markman() {
    file="${1-README.md}"
    pandoc -s -f markdown -t man "$file" \
      -M header="$(basename "$file")" \
      -M footer="$(readlink -f "$file")" \
    | man -l -
  }
  if ! iscommand readme; then
    alias readme=markman
  fi
fi
