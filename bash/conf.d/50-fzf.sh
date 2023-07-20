#!/usr/bin/env bash

# add fzf keybindings and completion if it is installed
if command -v fzf >/dev/null; then

  # use breadth-first search when available
  if command -v bfs >/dev/null; then
    export FZF_DEFAULT_COMMAND="bfs -s -nocolor 2>/dev/null"
    export FZF_CTRL_T_COMMAND="bfs -s -nocolor 2>/dev/null"
  fi

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
