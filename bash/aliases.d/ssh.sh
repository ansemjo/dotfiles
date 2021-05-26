#!/usr/bin/env bash

# provide a simple function to clean up ssh multiplexing sockets
# for usage with ssh config 'ControlPath /run/user/%i/sshmux-%r@%h:%p.sock'
SSHMUX_GLOB="/run/user/$EUID/sshmux-*.sock"
muxclean () {
  local g="$SSHMUX_GLOB"
  if [[ -z $1 ]]; then
    echo "\$ muxclean {all|user@host:port}" >&2 && return 1
  elif [[ $1 == all ]]; then
    # shellcheck disable=SC2086
    rm -Iv $g
  else
    mux="${g%%\**}$1${g##*\*}"
    if [[ -S $mux ]]; then
      rm -fv "$mux"
    else
      echo "no such mux: $mux" >&2 && return 1
    fi
  fi
}

_muxlist () {
  local g="$SSHMUX_GLOB"
  for f in $g; do
    if [[ "$f" != "$g" && $f =~ ${g%%\**}(.*)${g##*\*} ]]; then
      echo "${BASH_REMATCH[1]}"
    fi
  done
}

_muxclean () {
  # shellcheck disable=SC2034
  local cur prev words cword
  _init_completion || return
  [[ ${#words[@]} -gt 2 ]] && return
  local list len
  list=($(_muxlist)); len=${#list[@]};
  if [[ $len -eq 0 ]]; then
    #echo "no ssh muxes found for $SSHMUX_GLOB" >&2
    COMPREPLY=($(compgen -W "" "$cur"))
  elif [[ $len -eq 1 ]]; then
    COMPREPLY=($(compgen -W "${list[*]}" "$cur"))
  elif [[ $len -ge 2 ]]; then
    COMPREPLY=($(compgen -W "all ${list[*]}" "$cur"))
  fi
}
complete -F _muxclean muxclean


# ephemeral ssh connection without clobbering known-hosts file
alias sshnull="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ControlPath=none"
alias scpnull="scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ControlPath=none"
