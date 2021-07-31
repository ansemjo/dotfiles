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

if iscommand pdfpc; then

# present a pdf in windowed mode without scrollbars etc.
pdfpresenter() { pdfpc --switch-screens --single-screen --windowed presentation "$@"; }

fi
