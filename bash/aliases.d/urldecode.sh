#!/usr/bin/env bash

# use nodejs to url-encode/decode a string
if iscommand node; then
  urldecode() {
    node -e "process.stdin.resume(); process.stdin.setEncoding('utf8'); process.stdin.on('data', function(chunk) { process.stdout.write(decodeURIComponent(chunk)); });"
  }
  urlencode() {
    node -e "process.stdin.resume(); process.stdin.setEncoding('utf8'); process.stdin.on('data', function(chunk) { process.stdout.write(encodeURIComponent(chunk)); });"
  }
fi
