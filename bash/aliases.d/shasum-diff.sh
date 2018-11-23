# check files in two directories with sha*sum
shadiff() {
  shasum=${3:-sha384sum}
  (cd ${1:?first directory} && $shasum -- **) | \
    (cd ${2:?second directory} && $shasum -c -)
}
