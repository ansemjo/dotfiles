#!/usr/bin/bash

if iscommand qpdf; then

# concatenate files with qpdf
pdfcat() {
  if [[ -t 1 ]]; then
    echo "err: refusing to write to terminal" >&2
    return 1
  fi
  qpdf --empty --pages "$@" -- -
}

fi
