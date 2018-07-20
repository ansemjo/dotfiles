# make temporary directory with diceware words
mkdicetemp() { mktemp --tmpdir -d "tmp-$(words 2 -)-XXX"; }

# make and enter
mkcd() { ([[ -d ${1:?directory name required} ]] && echo "$1 already exists" >&2 || mkdir -p "$1") && cd "$1"; }

# make and enter a temporary directory
mkcdtmp() { cd $(mkdicetemp) && pwd; }

# switch to ephemeral directory
tmp() {
  t=$(mkdicetemp) \
    && pushd "$t" \
    && echo 'this directory will be removed upon exit' \
    && ${SHELL:-/usr/bin/env bash} \
    && popd \
    && rm -rf "$t"
}
