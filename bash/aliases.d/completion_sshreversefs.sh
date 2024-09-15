#!/usr/bin/env bash

if iscommand sshreversefs; then

_sshreversefs() {
  if iscommand _ssh; then
    _ssh
  else
    # shellcheck disable=SC2034
    local cur prev words cword
    _init_completion || return
    _known_hosts_real -a -- "$cur"
  fi
}
complete -F _sshreversefs sshreversefs

fi
