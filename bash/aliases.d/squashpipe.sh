#!/usr/bin/env bash

# e.g. sshnull -p 22 muliphein.semjonov.de dd if=/dev/sda bs=128k

squashpipe() {

  err() { echo "err: $1" >&2; usage; return 1; }
  usage() { cat >&2 <<USAGE
usage: $ squashpipe [-n name] [-m mode] [-c] archive.sqsh [extra]
  -n name    filename in archive
  -m mode    octal mode of file
  -c         create checksum file on-the-fly
  extra      extra arguments passed to mksquashfs
USAGE
}

  # defaults
  local ARCHIVE
  local NAME=image.bin
  local MODE=644
  local CHECKSUM=no

  # parse commandline
  local OPT OPTIND
  while getopts ":n:m:ch" OPT; do
    case "$OPT" in

      n) # filename
        NAME=$(sed 's/[ \\]/\\&/g' <<<"$OPTARG") ;;
      
      m) # octal mode
        [[ $OPTARG =~ ^[0-7]{3}$ ]] || { err "mode must be octal"; }
        MODE="$OPTARG" ;;

      c) # create checksum
        CHECKSUM=yes ;;

      # help, invalid, etc.
      h) usage; return 1 ;;
      \?) err "invalid option: $OPTARG" ;;
      :) err "invalid option: $OPTARG requires an argument" ;;

    esac
  done
  shift $((OPTIND - 1))

  # at least archive filename is required
  [[ $# -eq 0 ]] && { err "archive filename is required!"; }
  ARCHIVE="$1"; shift 1;

  # create an empty dummy directory, so there is no other file in archive
  tmp=$(mktemp -d --tmpdir squashpipe-tmp-XXXXXXXXX)
  mkdir -p "$tmp/empty"
  trap "rm -rf ${tmp@Q}" RETURN

  # constructed mksquash command
  sqsh() { mksquashfs "$tmp/empty" "$ARCHIVE" -all-root -quiet -p "$NAME f $MODE 0 0 cat" "$@"; }

  # let's roll
  if [[ $CHECKSUM = yes ]]; then
    [[ $NAME = SHA256SUM ]] && { err "filename conflicts with checksum"; }
    tee >(sha256sum | head -c66 >"$tmp/SHA256SUM") | sqsh "$@"
    echo "$NAME" >>"$tmp/SHA256SUM"
    mksquashfs "$tmp/SHA256SUM" "$ARCHIVE" -all-root -quiet -no-progress >/dev/null
  else
    sqsh "$@"
  fi  

}
