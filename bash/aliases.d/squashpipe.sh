#!/usr/bin/env bash

# write a file from stdin to a squashfs archive and
# optionally create a signed checksum on-the-fly
# e.g.:  dd if=/dev/sda | squashpipe archive.sqsh
#
# alternative for acquisition of forensic evidence containers from
# local harddisks: sfsimage (https://digitalforensics.ch/sfsimage/)
#
# the tl;dr-variant if this command is:
#  $ ... | tee >(sha256sum >/tmp/checksum) |\
#     mksquashfs /tmp/empty archive.sqfs -p "stdin.bin f 644 0 0 cat"
#  $ mksquashfs /tmp/checksum archive.sqfs
#
squashpipe() {

  err() { echo "err: $1" >&2; usage; return 1; }
  usage() { cat >&2 <<USAGE
usage: $ squashpipe [-n name] [-m mode] [-s seckey] archive.sqsh [extra]
 (reads from stdin and writes a pseudofile + its checksum to archive)
  -n name    filename in archive
  -m mode    octal mode of file
  -s seckey  create signed checksum with signify on-the-fly
  extra      extra arguments passed to mksquashfs
USAGE
}

  # defaults
  local ARCHIVE
  local NAME=image.bin
  local MODE=644
  local SIGN=no
  local SECKEY

  # parse commandline
  local OPT OPTIND
  while getopts ":n:m:s:h" OPT; do
    case "$OPT" in

      n) # filename
        # TODO: sanitize the filename a little? signify can't handle
        # all of them when verifying checksums ("invalid base64 encoding")...
        NAME="$OPTARG" ;;
      
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

  # common mksquashfs arguments
  sqargs=("$ARCHIVE" "-quiet")
  # use zstd if it is available
  if mksquashfs -help | grep "zstd" >/dev/null; then
    sqargs+=("-comp" "zstd")
  fi
  # add all-root if it is available
  if mksquashfs -help | grep "^-all-root" >/dev/null; then
    sqargs+=("-all-root")
  fi

  # run in subshell
  ( set -eo pipefail
  
  # create an empty dummy directory, so there is no other file in archive
  dummy=$(mktemp -d --tmpdir squashpipe-tmp-XXXXXXXXX)
  mkdir -p "$dummy/empty"
  # shellcheck disable=SC2064
  trap "rm -rf ${dummy@Q}" RETURN

  # let's roll, add file and compute checksum
  tee >(sha256sum --tag | awk -v "NAME=$NAME" '{ $2 = "(" NAME ")"; print; }' >"$dummy/$NAME.sha256") \
    | mksquashfs "$dummy/empty" "${sqargs[@]}" -p "$(sed 's/[&" \\]/\\&/g' <<<"$NAME") f $MODE 0 0 cat" "$@";
  # append (optionally signed) checksum
  if [[ $SIGN = yes ]]; then
    echo "signing checksum ..." >&2
    signify -S -e -m - -s "$SECKEY" -x "$dummy/$NAME.sig" < "$dummy/$NAME.sha256"
    sed -i '1c untrusted comment: verify with `signify -Cx *.sig -p /path/to/key.pub`' "$dummy/$NAME.sig"
    mksquashfs "$dummy/$NAME.sig" "${sqargs[@]}" -no-progress >/dev/null
  else
    mksquashfs "$dummy/$NAME.sha256" "${sqargs[@]}" -no-progress >/dev/null
  fi
  )

}
