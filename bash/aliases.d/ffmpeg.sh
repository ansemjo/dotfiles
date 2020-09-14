#!/usr/bin/env bash
if iscommand ffmpeg; then

# download and assemble a m3u8 stream
# expects a link and a filename
# --------------------------------------------------
ffmpeg-stream() {
  usage() { cat <<USAGE
Usage: $ ffmpeg-stream https://domain/path.m3u8 filename.mp4 [extra options]
Use USERAGENT env to override default -user_agent argument.
USAGE
}
  if [[ -z $1 ]] || [[ -z $2 ]]; then
    usage >&2; return 1;
  fi
  link="$1"; file="$2"; shift 2;
  ua="${USERAGENT:-Mozilla/5.0 (X11; Linux x86_64; rv:75.0) Gecko/20100101 Firefox/75.0}"
  ffmpeg -hide_banner -loglevel error -stats \
    -user_agent "$ua" -i "$link" -c copy "$@" "$file";
}

# concatenate video files with ffmpeg
# expects absolute filenames on stdin, one per line
# --------------------------------------------------
ffmpeg-concat() {
  ffmpeg -hide_banner -f concat -safe 0 \
    -i <(while read -r line; do \
      readlink -f "$line" | sed -e "s/'/'\\\''/g" -e "s/\(.*\)/file '\1'/"; \
    done) "$@";
}


# cut sections from a longer video and save to individual files
# https://stackoverflow.com/a/42827058
# --------------------------------------------------
ffmpeg-sections() (

  usage() { cat <<USAGE
usage: $ ffmpeg-sections -s 00:00-05:00 [-s ...] movie.mp4 [extra args]
  -s from-until   section specifier timestamps [hh:mm:ss.nnn]
  movie.mp4       input file
  extra args      extra arguments given to ffmpeg, e.g. -c:v hevc
USAGE
}

  # parse commandline for sections
  local SECTIONS=()
  local opt OPTIND
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

)


# transcode videos with ffmpeg to a different codec and container
# by default encodes with the new hevc codec and copies audio
# --------------------------------------------------
ffmpeg-recode() (

# print usage information
usage() { echo "usage: $ ffmpeg-recode [-v codec] [-a codec] [...] [-o outfile] [-h] infile" >&2; }
manual() { cat >&2 <<MANUAL
Transcode videos with ffmpeg to a more efficient format.
usage: $ ffmpeg-recode [-v codec] [-a codec] [-p preset] [-q quality] \\
          [-o outfile] [-h] infile [extra args]
  -v vcodec  : video encoder (hevc/h264/vp9/...)
  -a acodec  : autio encoder (copy/aac/opus/...)
  -p preset  : encoder preset (ultrafast..veryfast..medium..slow)
  -q quality : quality (crf) setting
  -o outfile : output file (default: \$input_\$codec.\$ext)
  -h         : show usage help
  infile     : input video file
  extra args : extra ffmpeg arguments
MANUAL
}

  err() { echo "err: $1" >&2; usage; }

  # set defaults:
  local vcodec="hevc"       # video codec
  local acodec="aac"        # audio codec
  local preset="veryfast"   # encoder preset
  local quality=()          # quality factor
  local output input        # output and input filename

  # commandline parser
  local opt OPTIND
  while getopts ":v:a:p:q:o:h" opt; do
    local arg="${OPTARG}"
    case "${opt}" in

      v) # video codec selection
        case "${arg}" in
          libx265|x265|h265|hevc) vcodec=hevc;;
          libx264|x264|h264|avc) vcodec=h264;;
          libvpx|libvpx-vp9|vp9|webm) vcodec=vp9;;
          *) vcodec="${arg}";;
        esac ;;

      a) # audio codec selection
        case "${arg}" in
          copy) acodec=copy;;
          aac) acodec=aac;;
          opus) acodec=libopus;;
          *) acodec="${arg}";;
        esac ;;

      p) # encoding preset
        case "${arg}" in
          ultrafast|superfast|veryfast|faster|\
            fast|medium|slow|veryslow) preset="${arg}";;
          *) err "unknown preset: ${arg}"; return 1;;
        esac;;

      q) # quality factor
        case "${arg}" in
          ''|*[!0-9]*) err "quality/crf must be an integer: ${arg}"; return 1;;
          *) quality=("-crf" "${arg}")
        esac;;

      o) # specific output filename
        output="${arg}";;

      h) # usage help
        manual; return 0;;

      \?) # unknown option
        err "invalid option: ${arg}"; return 1;;

      :) # missing argument
        err "invalid option: ${arg} requires an argument"; return 1;;

    esac
  done
  shift $((OPTIND-1))

  # input file required in first argument
  if [[ -z ${1+undefined} ]]; then
    err "input file required"; return 1;
  else
    input="${1}"
    shift 1
  fi

  # output file optional, use suffixed input by default
  if [[ -z ${output+undefined} ]]; then
    #local ext="$(sed -n 's/.*\.\([0-9a-z]\{2,4\}\)$/\1/ip' <<<"${input}")"
    #output="${input}_${vcodec}.${ext:-mp4}"
    output="${input}_${vcodec}.mp4"
  fi

  # print executed command and run ffmpeg
  echo "+ ffmpeg-recode: v=$vcodec a=$acodec p=$preset ${quality[1]/#/q=}"
  set -x
  ffmpeg "$@" \
    -i "${input}" \
    -hide_banner -loglevel error -stats \
    -c:v "${vcodec}" \
      -x265-params log-level=error \
      -preset "${preset}" \
      "${quality[@]}" \
      -pix_fmt yuv420p \
      -movflags +faststart \
    -c:a "${acodec}" \
    "${output}"
  { set +x; } 2>/dev/null

)

iscommand recode || alias recode=ffmpeg-recode

fi

if iscommand ffprobe; then

# display media info in json format for consumption with e.g. jq
# --------------------------------------------------
alias ffprobe-json='ffprobe -v error -print_format json -show_streams -show_format'
alias ffjson=ffprobe-json

fi
