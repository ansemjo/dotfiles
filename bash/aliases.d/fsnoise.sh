#!/usr/bin/env bash
# create some "filesystem noise" in the current directory by
# creating directories and files randomly
fsnoise() {
  D=$1; F=$2; R=${3:-30};
  if [[ -z $D ]] || [[ -z $F ]]; then
    printf 'fsnoise  a..f   0..9   [rand%%]\n' >&2
    printf '         ^dirs  ^files  ^percentage\n' >&2
    return 1
  fi
  # shellcheck disable=SC1083
  for d in $(eval echo {"$D"}); do
    # shellcheck disable=SC1083
    for f in $(eval echo {"$F"}); do
      [[ $RANDOM -lt $(( 327 * R )) ]] && {
        echo "$d/$f"
        mkdir -p "$d"
        uuidgen > "$d/$f"
      }
    done
  done
  return 0
}
