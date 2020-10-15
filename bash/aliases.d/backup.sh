#!/usr/bin/env bash

# create simple backups with borg .. this command is used mainly as reference
# or starting point to write a more complete automated backup script.
# WARNING: this does not use encryption or authentication!
if iscommand borg && ! iscommand backup; then

  backup() {
    
    set -u -o pipefail
    repo="${1:?repository path required}";
    name="$(uuidgen)";
    shift 1;
    
    # init if repo does not exist / is empty directory
    if ! [[ -e $repo ]] || [[ -z $(ls -A "$repo") ]]; then
      mkdir -p "$repo"
      borg init --append-only --encryption none "$repo" \
        || return $?;
    fi

    # check if this is indeed a borg repo
    borg info "$repo" >/dev/null \
      || return $?;

    # create new backup
    borg create --compression zstd --stats --progress "$repo::$name" "$@" \
      || return $?;

  }

fi
