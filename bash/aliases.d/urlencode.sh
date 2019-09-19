#!/usr/bin/env bash

# use nodejs to url-encode/decode a string
#if iscommand node; then
#  urldecode() {
#    node -e "process.stdin.resume(); process.stdin.setEncoding('utf8'); process.stdin.on('data', function(chunk) { process.stdout.write(decodeURIComponent(chunk)); });"
#  }
#  urlencode() {
#    node -e "process.stdin.resume(); process.stdin.setEncoding('utf8'); process.stdin.on('data', function(chunk) { process.stdout.write(encodeURIComponent(chunk)); });"
#  }
#fi

# use modified urlencode and urldecode from https://github.com/dylanaraps/pure-bash-bible#percent-encode-a-string
urlencode() {
  if [[ -t 0 ]]; then
    s="$1"
  else
    s="$(cat)"
  fi
  local LC_ALL=C
  for (( i = 0; i < ${#s}; i++ )); do
    : "${s:i:1}"
    case "$_" in
      [a-zA-Z0-9.~_-])
        printf '%s' "$_" ;;
      *)
        printf '%%%02X' "'$_" ;;
    esac
  done
  printf '\n'
}
urldecode() {
  if [[ -t 0 ]]; then
    s="$1"
  else
    s="$(cat)"
  fi
  : "${s//+/ }"
  printf '%b\n' "${_//%/\\x}"
}
