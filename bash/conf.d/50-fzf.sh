#!/usr/bin/env bash

# add fzf keybindings and completion if it is installed
if command -v fzf >/dev/null; then

  for dir in /usr/share/fzf /usr/share/doc/fzf/examples; do
    if [[ -d $dir ]]; then
      for file in key-bindings.bash completion.bash; do
        if [[ -r $dir/$file ]]; then
          source "$dir/$file"
        fi
      done
    fi
  done

fi
