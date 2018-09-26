# strip ansi escape codes from text
# will only work with GNU sed
# https://stackoverflow.com/a/43627833
alias strip-ansi-escapes='sed "s,\x1B\[[0-9;]*[a-zA-Z],,g"'
