#!/usr/bin/env bash
if iscommand ffmpeg; then

# hide ffmpeg banner by default
# shellcheck disable=SC2262,SC2263
alias ffmpeg="ffmpeg -hide_banner"

# progress output that comfortably fits in 80 columns ...
# use it like: ffmpeg-recode -l info [...] 2>&1 | ffmpeg-progress
#
# TODO: this leaves ffmpeg hanging as a background job if
#  aborted with ctrl-c. not sure why that is? use kill %1.
# --------------------------------------------------
ffmpeg-progress() {
  stdbuf -o0 tr "\r" "\n" \
    | grep --line-buffered -E "(Duration:|^frame=)" \
    | while read -r line; do
      if [[ $line =~ Duration ]]; then
        dur=$(sed "s/.*Duration: \+\([0-9:.]\+\),.*/\1/" <<<"$line")
        printf ' %11s / %11s %10s %8s %14s\n' current total size speed bitrate
      elif [[ $line =~ ^frame= ]]; then
        status=($(sed "s/.*size= *\([0-9]\+kB\) time=\([0-9:.]\+\) bitrate= *\([0-9.]\+kbits\/s\) .*speed= *\([0-9.]\+x\).*/\2 \1 \4 \3/" <<<"$line"))
        printf '\033[2K\r %s / %s %10s %8s %14s' "${status[0]}" "$dur" "${status[@]:1}"
        #echo -ne "\033[2K\r${status[0]}/$dur ${status[1]} ${status[2]} ${status[3]}"
      fi
    done
    echo
}

# download and assemble a m3u8 stream
# expects a link and a filename
# --------------------------------------------------
ffmpeg-stream() {
  if [[ $# -lt 2 ]] || [[ $1 = "-h" ]]; then
    printf >&2 '%s\n' \
      'Usage: $ ffmpeg-stream https://domain/path.m3u8 filename.mp4 [extra options]' \
      'Use USERAGENT env to override default -user_agent argument.'
    return 1;
  fi
  local LINK="$1"; shift 1;
  local USERAGENT="${USERAGENT:-Mozilla/5.0 (X11; Linux x86_64; rv:87.0) Gecko/20100101 Firefox/87.0}";
  ffmpeg -stats -user_agent "$USERAGENT" -i "$LINK" -c copy "$@";
}

# concatenate video files with ffmpeg
# expects absolute filenames on stdin, one per line
# --------------------------------------------------
ffmpeg-concat() {
  ffmpeg -f concat -safe 0 \
    -i <(while read -r line; do printf 'file %q\n' "$(readlink -f "$line")"; done) \
    -c copy "$@";
}


# cut sections from a longer video and save to individual files
# https://stackoverflow.com/a/42827058
# --------------------------------------------------
ffmpeg-sections() {

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
  local name ext n
  name="$(basename "$INFILE")"
  ext="${name##*.}"
  n=0
  name() { printf '%s_s%02d_%s_%s.%s' "$name" "$n" "$1" "$2" "$ext"; }

  # generate -ss and -to arguments from segment selectors
  local SECTIONARGS=()
  for section in "${SECTIONS[@]}"; do
    local start="${section%%-*}"
    local until="${section##*-}"
    : $((n++))
    SECTIONARGS+=("-c" "copy" "$@" "-ss" "$start" "-to" "$until" "$(name "$start" "$until")")
  done

  ffmpeg -i "$INFILE" "${SECTIONARGS[@]}"

}

# cut sections and concatenate them directly
# --------------------------------------------------
ffmpeg-reslice() {

  usage() { cat <<USAGE
usage: $ ffmpeg-reslice -s 00:00-05:00 [-s ...] movie.mp4 [sliced.mp4]
  -s from-until   section specifier timestamps [hh:mm:ss.nnn]
  movie.mp4       input file
  sliced.mp4      output file (default: \${input}_sliced.mp4)
USAGE
}

  # parse commandline for sections
  local SECTIONS=()
  local opt OPTIND
  while getopts 's:' opt; do
    case "$opt" in
      s) SECTIONS+=("-s" "$OPTARG") ;;
      *) usage >&2; return 1 ;;
    esac
  done
  shift $((OPTIND - 1))

  # one argument required with filename
  if [[ -z ${1+undef} ]]; then
    echo "err: input filename required"
    usage >&2
    return 1
  fi
  INFILE="$1"
  local name ext
  name="$(basename "$INFILE")"
  ext="${name##*.}"
  shift 1

  # outfile name generator
  if [[ -n ${2+def} ]]; then
    OUTFILE="$2"
  else
    OUTFILE="${name}_resliced.${ext}"
  fi

  # scripted slice and concatenate
  ffmpeg-sections "${SECTIONS[@]}" "$INFILE" -loglevel error -stats
  # shellcheck disable=SC2012
  ls -1 "${name}"_s??_*."${ext}" | ffmpeg-concat -loglevel error -stats "$OUTFILE"
  rm -fv "${name}"_s??_*."${ext}"

}


# transcode videos with ffmpeg to a different codec and container
# by default encodes with the new hevc codec and copies audio
# --------------------------------------------------
ffmpeg-recode() {

# EXAMPLE on how to use hevc_vaapi hardware encoder, probably not easily reuseable
# ffmpeg-recode input.mp4 \
#   -I "-vaapi_device /dev/dri/renderD128" \
#   -v hevc_vaapi -- \
#     -vf format=nv12,hwupload \
#     -rc_mode CQP -global_quality 28 \
#     -profile:v main output.mp4

# print usage information
usage() { echo "usage: $ ffmpeg-recode infile [-v codec] [-a codec] [-h] [...] outfile" >&2; }
manual() { cat >&2 <<MANUAL
Transcode videos with ffmpeg to a more efficient format.
usage: $ ffmpeg-recode infile [-v codec] [-a codec] [-p preset] [-q quality] \\
          [-l loglvl] [-I inargs] [-o] [-h] -- [extra args] outfile
  -v vcodec  : video encoder (hevc/h264/vp9/...)
  -a acodec  : autio encoder (copy/aac/opus/...)
  -p preset  : encoder preset (ultrafast..veryfast..medium..slow)
  -q crf     : quality setting (h264~23, hevc~28)
  -s scale   : rescale video with vf
  -l loglvl  : loglevel (quiet..error..warning..info..debug)
  -I inargs  : extra ffmpeg arguments before input file
  -o         : generate output filename as \$input_\$vcodec.mp4
  -h         : show usage help
  extra args : extra ffmpeg arguments before output file
  infile     : input video file
  outfile    : output file
MANUAL
}

  err() { echo "err: $1" >&2; usage; }

  # set defaults:
  local vcodec="hevc"       # video codec
  local acodec="aac"        # audio codec
  local preset="veryfast"   # encoder preset
  local quality=()          # quality factor
  local scale=()            # scale video
  local input output        # input and generate output filename
  local loglvl=""           # logging level
  local inargs              # extra input arguments

  # input file required in first argument
  if [[ -z ${1+undefined} ]]; then
    err "input file required"; return 1;
  elif [[ $1 = "-h" ]]; then
    manual; return 0;
  else
    input="${1}"
    shift 1
  fi

  # commandline parser
  local opt OPTIND
  while getopts ":v:a:p:q:s:l:I:oh" opt; do
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

      s) # scale filter
        scale=("-vf" "scale=${arg}");;

      o) # generate output filename
        output="${input}_${vcodec}.mp4";;

      l) # adjust loglevel
        loglvl="${arg}";;

      I) # extra input arguments
        inargs="${arg}";;

      h) # usage help
        manual; return 0;;

      \?) # unknown option
        err "invalid option: ${arg}"; return 1;;

      :) # missing argument
        err "invalid option: ${arg} requires an argument"; return 1;;

    esac
  done
  shift $((OPTIND-1))

  # at least another argument with an output filename is required
  if [[ -z $output ]] && [[ $# -eq 0 ]]; then
    err "at least another output filename is required!"; return 1;
  fi

  # assemble an array of arguments
  args=("$@");
  [[ -n $output ]] && args+=("$output");

  # print executed command and run ffmpeg
  echo "+ settings: v=$vcodec a=$acodec p=$preset ${quality[1]/#/q=}"
  set -x
  # shellcheck disable=SC2046,SC2086
  ffmpeg $inargs \
    -i "${input}" \
    -hide_banner -loglevel "${loglvl:-info}" -stats \
    -c:v "${vcodec}" \
      -x265-params log-level="${loglvl:-warning}" \
      -preset "${preset}" \
      "${quality[@]}" \
      -pix_fmt yuv420p \
      -movflags +faststart \
    -c:a "${acodec}" \
    "${scale[@]}" \
    "${args[@]}";
  { set +x; } 2>/dev/null

}

iscommand recode || alias recode=ffmpeg-recode

fi

if iscommand ffprobe; then

# display media info in json format for consumption with e.g. jq
# --------------------------------------------------
alias ffprobe-json='ffprobe -v error -print_format json -show_streams -show_format'
alias ffjson=ffprobe-json

fi
