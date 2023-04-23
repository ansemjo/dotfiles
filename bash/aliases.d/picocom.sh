#!/usr/bin/env bash

# picocom config for usb serial device
# most devices want 115200 baud nowadays ...
if iscommand picocom; then
  # TODO: crcrlf often leads to problems ..
  #alias picocom='picocom --baud 115200 --omap crcrlf,delbs --quiet'
  alias picocom='picocom --baud 115200 --quiet'
  # autocompletion with a few common paths
  # shellcheck disable=SC2010
  _picocom_serials() {
    flags=(--{baud,flow,parity,{data,stop}bits,{no-,}escape,no{init,reset},{i,o,e}map,logfile,{lower,raise}-{rts,dtr},exit,quiet,help});
    COMPREPLY=($(compgen -W "$(ls /dev/{tty,serial/by-id/}* 2>/dev/null | grep -vE '/tty(S?[0-9]+)?$' 2>/dev/null) ${flags[*]}" -- "${COMP_WORDS[-1]}"));
  }
  complete -F _picocom_serials picocom
fi

