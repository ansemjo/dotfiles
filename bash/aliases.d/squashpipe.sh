#!/usr/bin/env bash

# e.g. sshnull -p 22 muliphein.semjonov.de dd if=/dev/sda bs=128k

squashpipe() {

  err() { echo "err: $1" >&2; usage; return 1; }
  usage() { cat >&2 <<USAGE
usage: $ squashpipe [-n name] [-m mode] [-s seckey] archive.sqsh [extra]
  -n name    filename in archive
  -m mode    octal mode of file
  -s seckey  create signed checksum with signify on-the-fly
  extra      extra arguments passed to mksquashfs
USAGE
}

  # defaults
  local ARCHIVE
  local RAWNAME NAME=image.bin
  local MODE=644
  local SIGN=no
  local SECKEY

  # parse commandline
  local OPT OPTIND
  while getopts ":n:m:s:h" OPT; do
    case "$OPT" in

      n) # filename
        RAWNAME="$OPTARG"
        NAME=$(sed 's/[ \\]/\\&/g' <<<"$OPTARG") ;;
      
      m) # octal mode
        [[ $OPTARG =~ ^[0-7]{3}$ ]] || { err "mode must be octal"; }
        MODE="$OPTARG" ;;

      s) # create signature
        SECKEY="$OPTARG"
        SIGN=yes ;;

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

  # run in subshell
  ( set -eo pipefail
  
  # create an empty dummy directory, so there is no other file in archive
  dummy=$(mktemp -d --tmpdir squashpipe-tmp-XXXXXXXXX)
  mkdir -p "$dummy/empty"
  trap "rm -rf ${dummy@Q}" RETURN

  # constructed mksquash command
  sqsh() { mksquashfs "$dummy/empty" "$ARCHIVE" -all-root -quiet -p "$NAME f $MODE 0 0 cat" "$@"; }

  # let's roll
  if [[ $SIGN = yes ]]; then
    tee >(sha256sum --tag | awk -v "name=$RAWNAME" '{ gsub("-", name, $2); print }' >"$dummy/checksum") | sqsh "$@"
    mksquashfs "$dummy/checksum" "$ARCHIVE" -all-root -quiet -no-progress >/dev/null
    echo "signing checksum ..." >&2
    signify -S -e -m - -s "$SECKEY" -x "$dummy/checksum.sig" < "$dummy/checksum"
    mksquashfs "$dummy/checksum.sig" "$ARCHIVE" -all-root -quiet -no-progress >/dev/null
  else
    sqsh "$@"
  fi
  )

}
