# make temporary directory with diceware words
mkdicetemp() { mktemp --tmpdir -d "tmp-$(randomwords 2 -)-XXX"; }

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

# switch to ephemeral directory, which is deleted when
# exiting the nested shell level, i.e.:
#
# ~ $ tmp
# this directory will be removed upon exit
# /tmp/tmp-great-buck
# /tmp/tmp-great-buck $ [ do some work ... ]
# /tmp/tmp-great-buck $ ^Dexit
# ~ $ 
tmp() {
  history -w || true
  t=$(mknamedtemp) \
    && { $SHELL -c \
     "cd '$t' \
      && printf '\033[31m%s\033[0m\n' 'this directory will be removed upon exit' \
      && pwd \
      && exec $SHELL" \
     || true; \
    } \
    && if awk '{ print $2 }' /etc/mtab | grep "$t"; then
      echo -e "\033[31maborting removal due to mounts\033[0m" >&2
    else
      echo -e "\033[31mremoving temporary directory ...\033[0m" >&2
      rm -rf "$t"
    fi
}
