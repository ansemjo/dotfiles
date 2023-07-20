#!/usr/bin/env bash
# chmod files or directories recursively
chmodr() {

  # defaults
  local TYPE="all"
  # shellcheck disable=SC2034
  local VEBOSE=""
  
  # usage note and error
  usage() { echo "$ chmodr [-f | -d | -t type] [-v] mode directory"; }
  err() { echo "err: $1" >&2; usage >&2; }

  # argument parser
  local opt OPTIND OPTARG
  while getopts 'dft:vh' opt; do
    case $opt in
      d) TYPE="d" ;;
      f) TYPE="f" ;;
      t) TYPE="$OPTARG" ;;
      v) VERBOSE="-v" ;;
      h) usage; return 0 ;;
      *) usage; return 1 ;;
    esac
  done
  shift $((OPTIND - 1))

  # mode and directory must be present
  [[ -z $1 ]] && { err "mode must be given"; return 1; }
  [[ -z $2 ]] && { err "directory must be given"; return 1; }
  local MODE="${1:?mode required}"
  shift 1

  # find and chmod; @shellcheck: we *want* splitting on $VERBOSE so it's not passed as ""
  # shellcheck disable=SC2046,SC2086
  find "$@" $([[ $TYPE != all ]] && printf -- '-type %q' "$TYPE") -print0 | xargs -r -0 chmod $VERBOSE "$MODE"

}
