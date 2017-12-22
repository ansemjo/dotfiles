# simple wrappers around encrypt/decrypt aliases in openssl-pipe.sh
# packs and compresses a number of files with tar and bzip2, then encrypts with random password

aespak () {
  tar cj "$@" | encrypt rand -nosalt;
}

aesupak () {
  decrypt -nosalt | tar xjv;
}

# Usage:
#
# $ aespak ./documents > documents.aes
# 86Re4wF954DGxbS0W-MforvRiWa7_89~2.UdiQX.U5zPg
#
# $ aesupak < documents.aes
# enter aes-256-ctr decryption password:
#

