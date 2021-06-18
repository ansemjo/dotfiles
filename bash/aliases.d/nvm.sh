#!/usr/bin/env bash

# use lazy-loaded node version manager
# https://github.com/nvm-sh/nvm/issues/1277#issuecomment-501056081
if [[ -d /usr/share/nvm ]]; then
function nvm() {
  unset -f nvm
  . /usr/share/nvm/init-nvm.sh
  nvm ${1+"$@"}
}
fi

