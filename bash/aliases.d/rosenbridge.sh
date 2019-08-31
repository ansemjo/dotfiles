#!/usr/bin/env bash

# find a local unused port
# https://unix.stackexchange.com/a/248319
unusedport() {
  read LOWERPORT UPPERPORT < /proc/sys/net/ipv4/ip_local_port_range
  while :; do
    PORT="$(shuf -i $LOWERPORT-$UPPERPORT -n 1)"
    ss -lpn | grep -q ":$PORT " || break
  done
  echo "$PORT"
}

# pipe stuff over a forwarding port on a multiplexed ssh connection
# this is basically my older tarpipe function, but without the implicit tar
rosenbridge() {

usage() { cat <<README
$ $(basename "$0") {s|send} <port>      send input to forwarded port
$ $(basename "$0") {r|recv} <sshconn>   receive input from ssh connection
README
}

  # two arguments required
  if [[ -z $1 ]] || [[ -z $2 ]]; then
    usage >&2; return 1;
  fi

  # modeselektor
  case "$1" in

    # receiver
    r|recv|receive)
      # find unused port locally
      port=$(unusedport)
      # add forwarding in multiplexed connection
      remote=$(ssh -O forward -R "0:localhost:$port" "$2") || \
        { echo "are you connected?" >&2; return 1; }
      printf 'Listening on port \033[1m%s\033[0m remotely ...\n' "$remote" >&2
      # listen with netcat
      nc -l -p "$port"
      # cancel forwarding when done
      ssh -O cancel -R "0:localhost:$port" "$2"
    ;;

    # sender
    s|send)
      # just pipe to given port with bash
      cat >/dev/tcp/localhost/"$2"
    ;;

    # unknown
    *) usage >&2; return 1;;

  esac

}

_rosenbridge() {
  local cur prev words cword
  _init_completion || return

  # first argument is the command
  if [[ $cword -eq 1 ]]; then
    COMPREPLY=($(compgen -W "send receive" -- "$cur"))
    return
  fi

  # second argument
  if [[ $cword -eq 2 ]]; then
    # switch on command
    case "$prev" in
      
      s*) # sending -> listening ports
        local ports
        ports=$(ss -tlpn | sed -n 's/.*:\([0-9]\{5\}\) .*/\1/p' | sort | uniq)
        COMPREPLY=($(compgen -W "$ports" -- "$cur"))
        return
      ;;

      r*) # receive -> ssh known hosts
        _known_hosts_real -a -- "$cur"
        return
      ;;

    esac
  fi
  COMPREPLY=()
}
complete -F _rosenbridge rosenbridge

if ! iscommand rb; then
  alias rb=rosenbridge
  complete -F _rosenbridge rb
fi
