#!/usr/bin/env bash

# change GOPATH to tidy up homedir
# could also be added to /etc/profile.d/gopath.sh
export GOPATH=~/.local/go

# add $GOPATH/bin to $PATH if go is installed
if command -v go >/dev/null; then
  export PATH="${GOPATH:-$(go env GOPATH)}/bin:$PATH"
fi
