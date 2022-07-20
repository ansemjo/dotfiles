#!/usr/bin/env bash
# activate a python virtualenv or create one if none exists
venv () {
  # if venv/ exists
  if test -d venv; then
    if test -r venv/bin/activate; then
      source venv/bin/activate
    else
      echo "err: venv/: not a virtualenv" >&2
      return 1
    fi
  else
    python -m venv "$@" venv/
    source venv/bin/activate
  fi
}

