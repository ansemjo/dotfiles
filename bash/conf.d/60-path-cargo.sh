#!/usr/bin/env bash

# add local cargo installs to $PATH if dir is present
if [[ -d ~/.cargo/bin ]]; then
  export PATH=~/cargo/bin:"$PATH"
fi
