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

if iscommand gs; then

# try to make a pdf smaller by recompressing images etc.
pdfsmaller() {
  if [[ $1 == -h ]] || [[ -z $1 ]] || [[ -z $2 ]]; then
    echo "usage: $ pdfsmaller <input.pdf> <output.pdf> [setting]" >&2
    echo " where setting can be: screen, *ebook, printer, prepress" >&2
    return 1
  fi
  gs -sDEVICE=pdfwrite \
    -dPDFSETTINGS="/${3:-ebook}" -q \
    -o "$2" "$1";
}

fi

