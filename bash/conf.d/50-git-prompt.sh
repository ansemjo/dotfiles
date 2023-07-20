#!/usr/bin/env bash

# source git-prompt if needed
if ! command -v __git_ps1 >/dev/null; then
  for gitps1 in "/usr/share/git"{,-core/contrib}"/completion/git-prompt.sh"; do
    [[ -f $gitps1 ]] && . "$gitps1";
  done
fi
