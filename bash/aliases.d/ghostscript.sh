#!/usr/bin/env bash

# convert a pdf to grayscale, e.g. to "remove" previous highlighters
gs-grayscalepdf() {

usage() { cat <<USAGE
usage: gs-grayscale <input> <output> [extra args]
  input   : input file
  output  : output file
USAGE
}

  # defaults
  local input output
  
  # check for "help" flag
  if [[ $1 = '-h' ]]; then
    usage; return 0;
  fi

  # input file required
  if [[ -z ${1+undefined} ]]; then
    echo "err: input file required" >&2
    usage; return 1;
  else
    input="${1}"
    shift 1;
  fi

  # output file required
  if [[ -z ${1+undefined} ]]; then
    echo "err: output file required" >&2
    usage; return 1;
  else
    output="${1}"
    shift 1;
  fi

  # run command (https://stackoverflow.com/a/20133915)
  gs \
    -sDEVICE=pdfwrite \
    -sProcessColorModel=DeviceGray \
    -sColorConversionStrategy=Gray \
    -dOverrideICC \
    -o "${output}" \
    -f "${input}" \
    "$@";

}

