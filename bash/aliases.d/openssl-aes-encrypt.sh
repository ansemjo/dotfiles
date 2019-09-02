# DISCLAIMER: This usage of openssl produces __unauthenticated__ ciphertext,
# which should be avoided whenever possible and if AEAD ciphers are available.
# Shameless plug: use my https://github.com/ansemjo/aenker project or
# @FiloSottile's age tool once that's ready.

# encryption pipe using AES-256-CTR
# $ encrypt <document >ciphertext
# password: OKCZGYu92USjuDLB5ZzhfurjjT3QnCKLIzICfqC1Uw
aes-256-ctr-encrypt() {
  # use a random string with approx. 256 bits of entropy
  local passwd=$(tr -dc '[:alnum:]' </dev/urandom | head -c42);
  echo "password: $passwd" >&2;
  openssl enc -e -aes-256-ctr -md sha256 -pass "pass:$rand" "$@";
}

# decryption pipe using AES-256-CTR
# $ decrypt <ciphertext
# enter aes-256-ctr decryption password:
aes-256-ctr-decrypt() {
  # password is prompted
  openssl enc -d -aes-256-ctr -md sha256 "$@";
}

# add shorter alias if free
if ! iscommand encrypt && ! iscommand decrypt; then
  alias encrypt=aes-256-ctr-encrypt;
  alias decrypt=aes-256-ctr-decrypt;
fi