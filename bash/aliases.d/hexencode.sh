#!/usr/bin/env bash

if iscommand xxd; then

# encode stdin to hex
hexencode() { xxd -p | tr -d '\n'; }

# decode hex from stdin
# reverse of hexdump .. looking for this way too often
hexdecode() { xxd -r -p "$@"; }
alias unhex=hexdecode

fi
