#!/usr/bin/env bash

# add fzf keybindings and completion if it is installed
if command -v fzf >/dev/null; then

if [[ -d /usr/share/fzf ]]; then
  source /usr/share/fzf/key-bindings.bash
  source /usr/share/fzf/completion.bash
fi

if [[ -d /usr/share/doc/fzf/examples ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.bash
  source /usr/share/doc/fzf/examples/completion.bash
fi

fi
