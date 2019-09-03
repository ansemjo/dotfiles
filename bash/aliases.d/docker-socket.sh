#!/usr/bin/env bash

if iscommand docker; then

  # forward docker socket from remote host via ssh tunnel and set
  # environment for local docker to use forwarded socket
  docker-ssh-socket() {
    connect=${1:?destination host or ssh alias required}
    shift 1
    socket="$XDG_RUNTIME_DIR/docker-$connect.sock"
    rm -f "$socket" && \
    ssh -fN -n -T -o ControlPath=none -L "$socket:/var/run/docker.sock" "$connect" "$@" && \
    export DOCKER_HOST="unix://$socket"
  }

  _docker-ssh-socket() {
    if iscommand _ssh; then
      _ssh
    else
      local cur prev words cword
      _init_completion || return
      _known_hosts_real -a -- "$cur"
    fi
  }
  complete -F _docker-ssh-socket docker-ssh-socket

fi
