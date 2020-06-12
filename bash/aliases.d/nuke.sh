#!/usr/bin/env bash
# recursively shred files in given folder and then
# remove directories with rm -rf

if iscommand shred; then
  nuke() {
    if [[ -z $1 || ! -d $1 ]]; then
      echo "specify directory: '$ nuke directory'"
      return 1
    fi
    local n=$(find "$1" -type f -print | wc -l)
    read -r -n 1 -p "this will completely delete $n files. are you sure? (y/N) " confirm
    echo
    if [[ $confirm == 'y' ]]; then
      find "$1" -type f -printf 'shred %p\n' -exec shred --remove=wipe {} \; && rm -rvf "$1";
    else
      return 1
    fi
  }
fi
