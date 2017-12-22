# encrypt pipe using AES-256-CTR
encrypt() {
  if [[ ${1,,} =~ ^rand ]]; then shift;
    # if the first argument matches '/^rand/i', use a random string with
    # approximately 256 bits of entropy and echo that to stderr
    rand=$(</dev/urandom tr -dc '[:alnum:]_.~-' | head -c45);
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
# $ encrypt rand <document >ciphertext
# 3Hrb9NyAPGvL4bCBZI5iKLo7JDTJuam0+6GpSiyHyPg=
#
# $ decrypt <ciphertext
# enter aes-256-ctr decryption password:
#
# Alternatives:
#
# // Use a password file:
# $ encrypt <document >ciphertext 2>pwfile
# $ decrypt <ciphertext -pass file:pwfile
#
# // Use -in/-out parameters:
# $ encrypt rand -in document -out ciphertext
#
# // Prompt for encryption password by omitting 'rand':
# $ encrypt <document >ciphertext
# enter aes-256-ctr encryption password:
# Verifying - enter aes-256-ctr encryption password:
#
# // Use no salt. Resulting file should look completely random:
# // You should NOT use this with a prompted password!
# $ encrypt <document rand -nosalt >ciphertext
# 6HXjLgrneZCqlTbGMk6cQwP9KNmzorQhCA0bnM74v44=
# $ xxd ciphertext
# 00000000: f837 9708 22ea e98e ca1e 2da1 53bd 413a  .7..".....-.S.A:
# 00000010: 5430 000a 461e 63b1 f5d7 6353 2048 f145  T0..F.c...cS H.E
# ...
# $ decrypt <ciphertext -nosalt
# enter aes-256-ctr decryption password:
#

