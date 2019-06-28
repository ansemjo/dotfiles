# make temporary directory with diceware words
mkdicetemp() { mktemp --tmpdir -d "tmp-$(words 2 -)-XXX"; }

# make and enter
mkcd() { ([[ -d ${1:?directory name required} ]] && echo "$1 already exists" >&2 || mkdir -p "$1") && cd "$1"; }

# make temporary directory with docker name generator
mknamedtemp() {
  tmp=${TMPDIR:-/tmp}
  while true; do
    dir="$tmp/tmp-$(randomname)"
    if mkdir "$dir"; then echo "$dir"; return 0; fi
  done
}

# make and enter a temporary directory
mkcdtmp() { cd $(mknamedtemp) && pwd; }

# switch to ephemeral directory
tmp() {
  t=$(mknamedtemp) \
    && { $SHELL -c \
     "cd '$t' \
      && printf '\033[31m%s\033[0m\n' 'this directory will be removed upon exit' \
      && pwd \
      && exec $SHELL" \
     || true; \
    } \
    && rm -rf "$t"
}
