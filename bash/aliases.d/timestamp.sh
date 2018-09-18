# iso-like format but with alphabetic timezone
timestamp() { date --utc +%FT%T%Z; }

# timestamp for filename usage
timestampfn() { date --utc +%F-%H%M%S%Z; }
