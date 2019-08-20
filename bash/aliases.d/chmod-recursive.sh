# chmod files or directories recursively
chmodr() {

  # defaults
  local TYPE="all"
  local VEBOSE=""
  
  # usage note and error
  usage() { echo "$ chmodr [-f | -d | -t type] [-v] mode directory"; }
  err() { echo "err: $1" >&2; usage >&2; }

  # argument parser
  local OPTIND=0
  while getopts 'dft:vh' opt; do
    case $opt in
      d) local TYPE="d" ;;
      f) local TYPE="f" ;;
      t) local TYPE="$OPTARG" ;;
      v) local VERBOSE="-v" ;;
      h) usage; return 0 ;;
    esac
  done
  shift $((OPTIND - 1))

  # mode and directory must be present
  [[ -z $1 ]] && { err "mode must be given"; return 1; }
  [[ -z $2 ]] && { err "directory must be given"; return 1; }
  local MODE="${1:?mode required}"
  shift 1

  # find and chmod
  find "$@" $([[ $TYPE != all ]] && printf -- '-type %q' "$TYPE") -print0 | xargs -r -0 chmod $VERBOSE "$MODE"

}
