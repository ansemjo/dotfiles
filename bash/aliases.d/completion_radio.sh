#!/usr/bin/env bash
if iscommand mpv; then

# completion for channels
complete -W "$(command -V radio | sed -n 's/^ \+\([a-z]\+\))$/\1/p')" radio

# alias for some streams
alias ndr=radio
complete -W "info kultur" ndr
alias dlf="radio dlf"

fi
