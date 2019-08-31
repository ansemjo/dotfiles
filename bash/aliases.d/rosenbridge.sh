#!/usr/bin/env bash

# receive data over a forwarding port on a multiplexed ssh connection
# this is basically my older tarpipe function, but without the implicit tar
rosenbridge() {

usage() { cat <<README
$ $(basename "$0") [ssh args] host
Receive data over a forwarded port on a multiplexed ssh connection.
README
}

  # at least one argument required
  [[ -z $1 ]] && { usage >&2; return 1; }

  # create a new fifo
  fifo=$(mktemp -p "${TMPDIR:-/tmp}" -u rosenbridge-XXXXXX)
  mkfifo "$fifo"
  # check if mux master is running or (re)start
  if ! ssh -O check "$@" 2>/dev/null; then
    ssh -fN -M "$@" || { echo "can't open control master" >&2; return 1; }
  fi
  # add forwarding in multiplexed connection
  remote=$(ssh -O forward -R "0:$fifo" "$@") || \
    { echo "can't create forwarding" >&2; return 1; }
  printf 'Listening on port \033[1m%s\033[0m remotely ...\n' "$remote" >&2
  # listen with netcat
  nc -Ul "$fifo"
  # cancel forwarding and remove fifo when done
  # TODO: couldn't get traps for cleanup to work reliably so far ..
  ssh -O cancel -R "0:$fifo" "$@" 2>/dev/null
  rm -f "$fifo"

}
_rosenbridge() {
  if iscommand _ssh; then
    _ssh
  else
    local cur prev words cword
    _init_completion || return
    _known_hosts_real -a -- "$cur"
  fi
}
complete -F _rosenbridge rosenbridge

# simply pipe to a given local port, send data to rosenbridge
rbsend() {
  [[ -z $1 ]] && { echo -e "err: port required\n$ rbsend <port>" >&2; return 1; };
  cat >/dev/tcp/localhost/"${1:?port required}";
}
_rbsend() {
  local cur prev words cword  ports
  _init_completion || return
  ports=$(ss -tlpn | sed -n 's/.*:\([0-9]\{5\}\) .*/\1/p' | sort | uniq)
  COMPREPLY=($(compgen -W "$ports" -- "$cur"))
}
complete -F _rbsend rbsend

# add shorter alias if free
if ! iscommand rb; then
  alias rb=rosenbridge
  complete -F _rosenbridge rb
fi
