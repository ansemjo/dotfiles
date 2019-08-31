#!/usr/bin/env bash

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
      # create a new fifo
      fifo=$(mktemp -p "${TMPDIR:-/tmp}" -u rosenbridge-XXXXXX)
      mkfifo "$fifo"
      # check if mux master is running or (re)start
      if ! ssh -O check "$2" 2>/dev/null; then
        ssh -fN -M "$2" || { echo "can't open control master" >&2; return 1; }
      fi
      # add forwarding in multiplexed connection
      remote=$(ssh -O forward -R "0:$fifo" "$2") || \
        { echo "can't create forwarding" >&2; return 1; }
      printf 'Listening on port \033[1m%s\033[0m remotely ...\n' "$remote" >&2
      # listen with netcat
      nc -Ul "$fifo"
      # cancel forwarding and remove fifo when done
      # TODO: couldn't get traps for cleanup to work reliably so far ..
      ssh -O cancel -R "0:$fifo" "$2" 2>/dev/null
      rm -f "$fifo"
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
