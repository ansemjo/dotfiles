#!/usr/bin/env bash
# check files in two directories with sha*sum
shadiff() {
  shasum=${3:-sha256sum}
  (cd "${1:?first directory}" && find . -type f -exec "$shasum" {} \;) | \
    (cd "${2:?second directory}" && "$shasum" -c -)
}

# check for duplicate files by calculating checksum and printing duplicates
shadupes() {
  if [[ -n $1 ]]; then files=("$@"); else files=(*); fi
  echo "checking ${#files[@]} files with $(du -shc "${files[@]}" | tail -1) .."
  sha256sum "${files[@]}" | sort | uniq -w64 --all-repeated=prepend | cut -b 67-;
}
