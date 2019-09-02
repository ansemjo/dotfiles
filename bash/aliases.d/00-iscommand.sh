# check if the argument is a known command
iscommand() { command -v "$1" >/dev/null; }
