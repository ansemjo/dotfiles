#!/usr/bin/env bash

# upload to a mozilla send host that is behind basic auth
# see: https://gist.github.com/ansemjo/c24267ea4684a09dd841db910d908b9b
if iscommand ffsend; then
  function send() {
    # store user:password with $ secret-tool store --label="..." ffsend $FFSEND_HOST
    if [[ -z $FFSEND_HOST ]]; then
      echo "err: this command requires a host in FFSEND_HOST and stored credentials" >&2
      return 1
    fi
    ffsend upload \
      --host "$FFSEND_HOST" \
      --basic-auth "$(secret-tool lookup ffsend "$FFSEND_HOST")" \
      "$@";
  }
fi
