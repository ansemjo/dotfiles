#!/usr/bin/env bash

# picocom config for usb serial device
# most devices want 115200 baud nowadays ...
if iscommand picocom; then
  alias picocom='picocom --baud 115200 --omap crcrlf,delbs --quiet'
  # autocompletion with a few common paths
  # shellcheck disable=SC2010
  _picocom_serials() { COMPREPLY=($(compgen -W "$(ls /dev/{tty,serial/by-id/}* 2>/dev/null | grep -vE '/tty(S?[0-9]+)?$' 2>/dev/null)" "${COMP_WORDS[1]}")); }
  complete -F _picocom_serials picocom
fi

