#!/usr/bin/env bash

# add $GOPATH/bin to $PATH if go is installed
if command -v go >/dev/null; then
  export PATH="${GOPATH:-$(go env GOPATH)}/bin:$PATH"
fi
