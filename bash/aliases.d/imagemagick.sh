#!/usr/bin/env bash

# resize images with imagemagick in-place
imageres() {

  usage() { cat <<USAGE
usage: imageres [-i] [-s 40%] filename [output]
  -i       : convert in-place and overwrite original file
  -s 40%   : scaling factor, use any number or size accepted by -resize
  filename : input file
  output   : output file (when not using in-place)
USAGE
}

  # defaults
  local res="40%"
  local inplace="false"
  local input output

  # commandline parser
  local opt OPTIND
  while getopts "his:" opt; do
    local arg="${OPTARG}"
    case "${opt}" in

      h)  usage; return 0;;      # help
      \?) usage >&2; return 1;;  # invalid
      :)  usage >&2; return 1;;  # missing arg
      i)  inplace="true";;       # opt: in-place
      s)  res="${arg}";;         # opt: resize

    esac
  done
  shift $((OPTIND - 1))

  # input file required
  if [[ -z ${1+undefined} ]]; then
    echo "err: input file required" >&2
    usage; return 1;
  else
    input="${1}"
  fi

  # output file required if not in-place
  if [[ $inplace == true ]]; then
    output="${input}"
  else
    if [[ -z ${2+undefined} ]]; then
      echo "err: output file required" >&2
      usage; return 1;
    else
      output="${2}"
    fi
  fi

  # run command
  convert -strip -interlace Plane -gaussian-blur 0.05\
    -resize "${res}" -quality "85%" \
    "${input}" "${output}";

}

