# make and enter
mkcd () { ([[ -d ${1:?directory name required} ]] && echo "$1 already exists" >&2 || mkdir -p "$1") && cd "$1"; }

# make and enter a temporary directory
mkcdtmp () { cd $(mktemp -d) && pwd; }

# switch to completely temporary directory
tmp () { t=$(mktemp -d); test -n "$t" && pushd "$t" && bash && popd && rm -rf "$t"; }
