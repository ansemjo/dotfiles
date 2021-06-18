#!/usr/bin/env bash

# get the sha256 pubkey of a server for pinning with curl, in a TOFU fashion
# note that there's better ways with openssl if you have direct access to the certificate:
# https://blog.heckel.io/2020/12/13/calculating-public-key-hashes-for-public-key-pinning-in-curl/
getpinneypubkey() {
  url="${1:?url required}"
  if ! [[ $url =~ :// ]]; then
    url="https://$url"
  fi
  pin=$(curl "$url" --ssl --pinnedpubkey sha256//invalid -kv 2>&1 | sed -n 's/.*public key hash: //p')
  printf 'curl --pinnedpubkey %s ...\n' "$pin"
}

# download and inline checksum checking
curlsum() {

  # arguments
  link=${1:?download url}
  checksum=${2:?algorithm/checksum, e.g. sha256/af874ec29...)}

  # parse checksum arg (algorithm/checksum)
  alg=$(dirname "$checksum")
  KNOWNALG=(md5 sha1 sha224 sha256 sha384 sha512)
  # shellcheck disable=SC2076
  if [[ -z $alg ]] || [[ ! " ${KNOWNALG[*]} " =~ " ${alg} " ]] || ! which "${alg}sum" >/dev/null; then
    echo "unknown checksum algorithm: '$alg'" >&2; return 1;
  fi
  prog="${alg}sum"
  checksum=$(basename "$checksum")
  if [[ -z $checksum ]]; then
    echo "empty checksum?" >&2; return 1;
  fi
  
  # download file and check checksum simultaneously
  # redirect command stdout to write to file
  exec 3>&1
  set -o pipefail
  (curl -# -L "$link" | tee /dev/fd/3 | "$prog" -c <(echo "$checksum -") >/dev/null) 4>&1 1>&3 3>&4
  ret=$?
  exec 3>&-
  return $ret

}
