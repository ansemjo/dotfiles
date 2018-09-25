#!/usr/bin/env bash

# countdown with a spinning braille pattern
countdown() {

  ticks=$(( ${1:-10} * 10 ))
  message=${2:-waiting}

  pattern=(⡇ ⠏ ⠛ ⠹ ⢸ ⣰ ⣤ ⣆)
  pattern_len=${#pattern[@]}

  while [[ $ticks -gt 0 ]]; do
    printf '  %s [%02d] %s\r' "$message" "$(( $ticks / 10 ))" "${pattern[$i]}";
    i=$(( (i+1) % ${#pattern[@]} ))
    ticks=$(( ticks - 1 ))
    sleep "0.098" # compensate a little
  done

  printf '\rdone.                      \n';

}
