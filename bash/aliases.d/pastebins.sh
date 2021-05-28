#!/usr/bin/env bash

# post to https://paste.rs/
if iscommand curl; then
  pasters() {
    if [[ -n $1 ]]; then
      echo "usage: $ echo "Hello, World!" | pasters" >&2
      return 1
    fi
    curl --data-binary @/dev/stdin https://paste.rs/
  }
fi
