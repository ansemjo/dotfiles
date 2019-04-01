#!/usr/bin/env bash

# use nodejs to urldecode a string
if iscommand node; then
  urldecode() {
    node -e "process.stdin.resume(); process.stdin.setEncoding('utf8'); process.stdin.on('data', function(chunk) { process.stdout.write(decodeURIComponent(chunk)); });"
  }
fi
