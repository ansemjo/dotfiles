# create in-place copy.bak quickly
bak() { cp --reflink=auto --archive "${1%/}" "${1%/}.bak"; }
