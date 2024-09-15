#!/usr/bin/env bash

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
  # shellcheck disable=SC2034
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
