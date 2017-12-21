# encrypt pipe using AES-256-CTR
encrypt() {
  if [[ $1 == rand ]]; then
    # use random 256 bits base64 encoded as password
    # output ciphertext to stdout, echo password to stderr
    rand="pass:$(</dev/urandom head -c32 | base64)";
    openssl enc -e -aes-256-ctr -pass "$rand";
    echo "$rand" >&2;
  else
    # otherwise prompt by default and allow
    # further openssl enc options
    openssl enc -e -aes-256-ctr "$@";
  fi
}

# decrypt pipe using AES-256-CTR
decrypt() {
  # decrypt ciphertext from stdin and output to stdout
  # password is prompted by default, openssl enc options allowed
  openssl enc -d -aes-256-ctr "$@";
}
