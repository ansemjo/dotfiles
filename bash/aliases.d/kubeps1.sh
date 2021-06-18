#!/usr/bin/env bash

# toggle the display of kubernetes context on PS1
kubeps1() {
  if truthy "${1:-true}"; then
    export PS1_KUBERNETES=true
  else
    export PS1_KUBERNETES=false
  fi
}
