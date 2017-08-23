# create in-place copy.bak quickly
bak() { cp --archive "$(echo "$1" | sed 's|[/]*$||')"{,.bak}; }
