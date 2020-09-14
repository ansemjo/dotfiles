#!/usr/bin/env bash
# run ocr on pdfs with ocrmypdf (install via pip)
if iscommand ocrmypdf; then
ocr() {
  file=$1; shift 1;
  [[ -z $file ]] && {
    printf 'perform ocr on pdfs with ocrmypdf\nusage: %s <path/to/pdf> [<extra args>]\n' "$0" >&2;
    return 1;
  }
  ocrmypdf -cd "$@" "$file" "$file"
}
fi
