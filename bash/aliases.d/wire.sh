#!/usr/bin/env bash

wire() {

  profile=${1:?profile required}
  action=${2:-smart}

  case "$action" in

    up)
      sudo wg-quick up "$profile"
    ;;
    
    down)
      sudo wg-quick down "$profile"
    ;;
    
    toggle)
      if ip link show dev "$profile" &>/dev/null; then
        sudo wg-quick down "$profile"
      else
        sudo wg-quick up "$profile"
      fi
    ;;

    smart)
      if ip link show dev "$profile" &>/dev/null; then
        echo "err: link is already up ..." >/dev/stderr
        return 1
      else
        sudo wg-quick up "$profile" && \
        watch --color sudo WG_COLOR_MODE=always wg show "$profile";
        sudo wg-quick down "$profile";
      fi
    ;;

    *)
      echo "usage: wire <profile> {up|down|toggle|smart}" >&2
      exit 1
    ;;

  esac

}

_wire() {

  local cur prev words cword
  _init_completion || return

  # find profiles with shell glob
  local wp
  wp=(/etc/wireguard/*.conf)
  wp=(${wp[@]##*/})
  wp=(${wp[@]%%.conf})

  # current = 1 -> profile, 2 -> action
  case "$cword" in
    1) COMPREPLY=($(compgen -W "${wp[*]}" -- "$cur")) ;;
    2) COMPREPLY=($(compgen -W "up down toggle smart" -- "$cur")) ;;
    *) COMPREPLY=() ;;
  esac
}
complete -F _wire wire
