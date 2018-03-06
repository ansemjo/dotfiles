### OpenSSL shortcuts taken from: https://certsimple.com/blog/openssl-shortcuts
### Supplemented with some info from https://www.phildev.net/ssl/managing_ca.html

# view
alias openssl-view-cert='openssl x509 -text -noout -in'
alias openssl-view-request='openssl req -text -noout -verify -in'
alias openssl-view-revocationlist='openssl crl -noout -text -in'
alias openssl-view-key='openssl rsa -check -in'
alias openssl-view-pkcs12='openssl pkcs12 -info -in'
alias openssl-client='openssl s_client -status -connect'
openssl-client-getcert() { sni=$1; port=$2; shift; shift; </dev/null openssl s_client -status -connect "$sni:${port:-443}" -servername "$sni" "$@"; }

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
