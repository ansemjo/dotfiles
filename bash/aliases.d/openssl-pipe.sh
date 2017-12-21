# encrypt pipe using AES-256-CTR
encrypt() {
  if [[ ${1,,} =~ ^rand ]]; then shift;
    # if the first argument is '/^rand/i', use a random 256 bits
    # base64 encoded as password and echo that to stderr
    rand=$(</dev/urandom head -c32 | base64);
    openssl enc -e -aes-256-ctr -pass "pass:$rand" "$@";
    echo "$rand" >&2;
  else
    # prompt for password by default
    openssl enc -e -aes-256-ctr "$@";
  fi
}

# decrypt pipe using AES-256-CTR
decrypt() {
  # password is prompted by default
  openssl enc -d -aes-256-ctr "$@";
}

# Hint: Both commands are a pipe by default, i.e. stdin is encrypted
# and ciphertext is output to stdout. This behaviour can be changed
# with valid openssl enc options as arguments.
#
# Sample usage:
#
# $ encrypt rand <document.txt >ciphertext.aes
# 3Hrb9NyAPGvL4bCBZI5iKLo7JDTJuam0+6GpSiyHyPg=
#
# $ decrypt <ciphertext.aes
# enter aes-256-ctr decryption password:
#
# Alternatives:
#
# // Use a password file:
# $ encrypt <document.txt >ciphertext.aes 2>pwfile.txt
# $ decrypt <ciphertext.aes -pass file:pwfile.txt
#
# // Use -in/-out parameters:
# $ encrypt rand -in document.txt -out ciphertext.aes
#
# // Prompt for encryption password by omitting 'rand':
# $ encrypt <document.txt >ciphertext.aes
# enter aes-256-ctr encryption password:
# Verifying - enter aes-256-ctr encryption password:
#
