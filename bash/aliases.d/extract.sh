#!/usr/bin/env bash
# universal extraction function
extract () {
  if [[ ! -f $1 ]]; then
    printf '%q is not a valid file\n' "$1"
  else
    if [[ $1 =~ \.t((ar\.)?(bz2|gz|lz|xz|Z)|b2|bz|ar\.lzma)$ ]]; then
      (set -o xtrace; tar xf "$1";)
    else
      case "$1" in
        *.Z)    (set -o xtrace; uncompress  "$1";);;
	      *.gz)   (set -o xtrace; gunzip      "$1";);;
	      *.bz2)  (set -o xtrace; bunzip2     "$1";);;
	      *.zip)  (set -o xtrace; unzip       "$1";);;
	      *.rar)  (set -o xtrace; rar x       "$1";);;
	      *.7z)   (set -o xtrace; 7z x        "$1";);;
        *)      printf '%q cannot be extracted via extract()\n' "$1";;
      esac
    fi
  fi
}
