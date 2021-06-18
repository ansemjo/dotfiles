#!/usr/bin/env bash

# use rootless docker socket if one exists
if [[ -r $XDG_RUNTIME_DIR/docker.sock ]]; then
  export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/docker.sock"
fi

# use buildkit by default
export DOCKER_BUILDKIT=1

