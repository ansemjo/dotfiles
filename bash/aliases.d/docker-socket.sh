#!/usr/bin/env bash

if iscommand docker; then

  # forward docker socket from remote host via ssh tunnel and set
  # environment for local docker to use forwarded socket
  docker-ssh-socket() {
    connect=${1:?destination host or ssh alias required}
    ssh -nNT -L "$XDG_RUNTIME_DIR/docker-$connect.sock:/var/run/docker.sock" "$connect" \
      && export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/docker-$connect.sock"
  }

fi
