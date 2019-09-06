if iscommand ffmpeg; then

# concatenate video files with ffmpeg
# expects absolute filenames on stdin, one per line
ffmpeg-concat() {
  ffmpeg -hide_banner -f concat -safe 0 \
    -i <(while read line; do \
      readlink -f "$line" | sed -e "s/'/'\\\''/g" -e "s/\(.*\)/file '\1'/"; \
    done) "$@";
}

# cut sections from a longer video and save to individual files
# https://stackoverflow.com/a/42827058
ffmpeg-sections() {

  usage() {
cat <<USAGE
$ ffmpeg-sections -s 00:00-05:00 [-s ...] movie.mp4 [extra args]
  -s from-until   section specifier timestamps [hh:mm:ss.nnn]
  movie.mp4       input file
  extra args      extra arguments given to ffmpeg, e.g. -c:v hevc
USAGE
}

  # parse commandline for sections
  local SECTIONS=()
  while getopts 's:' opt; do
    case "$opt" in
      s) SECTIONS+=("$OPTARG") ;;
      *) usage >&2; return 1 ;;
    esac
  done
  shift $((OPTIND - 1))

  # one argument required with filename
  if [[ -z $1 ]]; then
    echo "err: filename required"
    usage >&2
    return 1
  fi
  INFILE="$1"
  shift 1

  # outfile name generator
  local name="$(basename "$INFILE")"
  local ext="${name##*.}"
  local n=0
  name() { printf '%s_s%02d_%s_%s.%s' "$name" "$n" "$1" "$2" "$ext"; }

  # generate -ss and -to arguments from segment selectors
  local SECTIONARGS=()
  for section in "${SECTIONS[@]}"; do
    local start="${section%%-*}"
    local until="${section##*-}"
    : $((n++))
    SECTIONARGS+=("-ss" "$start" "-to" "$until" "$(name "$start" "$until")")
  done

  ffmpeg -hide_banner -i "$INFILE" -c copy "$@" "${SECTIONARGS[@]}"

}

fi
