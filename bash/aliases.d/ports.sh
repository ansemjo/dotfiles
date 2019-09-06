# show listening ports and established connections
ports() { ss -tulnp "$@" | awk '{print $1 "\t" $2 "\t" $5 "\t" $7}' | column -t; }
