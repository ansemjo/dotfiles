# show listening ports and established connections
ports() { ss -tulnp "$@" | column -t; }
