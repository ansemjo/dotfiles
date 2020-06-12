#!/usr/bin/env bash
### OpenSSL shortcuts taken from: https://certsimple.com/blog/openssl-shortcuts
### Supplemented with some info from https://www.phildev.net/ssl/managing_ca.html

# view
alias openssl-view-cert='openssl x509 -text -noout -in'
alias openssl-view-cert-fingerprint='openssl x509 -noout -fingerprint -in'
alias openssl-view-request='openssl req -text -noout -verify -in'
alias openssl-view-revocationlist='openssl crl -noout -text -in'
alias openssl-view-key='openssl rsa -check -in'
alias openssl-view-pkcs12='openssl pkcs12 -info -in'
openssl-client() {
  host=${1##*://}; shift;
  if [[ $host =~ :[0-9]{1,5}$ ]]; then server="$host"; else server="$host:443"; fi
  openssl s_client -status -connect "$server" -servername "$host" "$@";
}
openssl-client-getcert() { openssl-client "$@" </dev/null | sed -n '/BEGIN CERTIFICATE/,/END CERTIFICATE/p'; }

openssl-check-modulus-cert() { openssl x509 -noout -modulus -in "${1}" | shasum -a 256; }
openssl-check-modulus-rsakey() { openssl rsa -noout -modulus -in "${1}" | shasum -a 256; }
openssl-check-modulus-request() { openssl req -noout -modulus -in "${1}" | shasum -a 256; }
openssl-file-encrypt() { openssl aes-256-cbc -in "${1}" -out "${2}"; }
openssl-file-decrypt() { openssl aes-256-cbc -d -in "${1}" -out "${2}"; }

openssl-help() { echo -e "
openssl req -new [-newkey rsa:....] [-nodes] -keyout KEY -out CSR
openssl ca [-create_serial -selfsign] [-extensions ...] [-days ...] -in CSR
openssl verify [-CAfile CACRT] -in CRT
"; }

openssl-install-ca() { ln -s "$1" "$(openssl x509 -hash -noout -in "$1").0"; }

# Convert PEM private key, PEM certificate and PEM CA certificate (used by nginx, Apache, and other openssl apps) to a PKCS12 file (typically for use with Windows or Tomcat)
openssl-convert-pem-to-p12() {
    test -n "$1" -a -n "$2" -a -n "$3" -a -n "$4" ||\
        { echo "\$1:key \$2:cert \$3:cacert \$4:out"; return 1; }
    openssl pkcs12 -export -inkey "${1}" -in "${2}" -certfile "${3}" -out "${4}"; }
openssl-convert-p12-to-pem() {
    test -n "$1" -a -n "$2" ||\
        { echo "\$1:p12-in \$2:out"; return 1; }
    openssl pkcs12 -nodes -in "${1}" -out "${2}"; }

openssl-gen-snakeoil() { openssl req -x509 -nodes -days 30 -newkey rsa:2048 -keyout "${1:?path required}.key" -out "${1:?}.crt"; }


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
