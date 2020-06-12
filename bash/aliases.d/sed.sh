#!/usr/bin/env bash
# pop first line of a file
popline() { sed -e "1w /dev/stdout" -e "1d" -i "${1:?file to pop}"; }

# strip ansi escape codes from text
# will only work with GNU sed
# https://stackoverflow.com/a/43627833
alias strip-ansi-escapes='sed "s,\x1B\[[0-9;]*[a-zA-Z],,g"'
