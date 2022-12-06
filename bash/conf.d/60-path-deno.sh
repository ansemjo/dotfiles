#!/usr/bin/env bash

# add local deno bin path to $PATH if deno is installed
if command -v deno >/dev/null || [[ -e ${DENO_INSTALL_ROOT:-$HOME/.deno/bin}/deno ]]; then
  export PATH="${DENO_INSTALL_ROOT:-$HOME/.deno/bin}:$PATH"
fi
