#!/usr/bin/env bash
# create some "filesystem noise" in the current directory by
# creating directories and files randomly
fsnoise() {
  D=$1; F=$2; R=${3:-30};
  [[ -n $D || -n $F ]] || {
    printf 'fsnoise {dirs} {files} [rand%%]\n' >&2
    return 1
  }
  for d in $(eval echo {$D}); do
    for f in $(eval echo {$F}); do
      [[ $RANDOM -lt $(( 327 * $R )) ]] && {
        echo $d/$f
        mkdir -p $d
        uuidgen > $d/$f
      }
    done
  done
  return 0
}
