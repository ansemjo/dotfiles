#!/usr/bin/env bash
# read environment from a simple KEY=value file without export
# commands, like it is commonly used for service environment files
readenv() {
  set -o allexport
  source "$1"
  set +o allexport
}
