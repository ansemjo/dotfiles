# watch with exit
if command -v watch &>/dev/null; then
    alias watcherr='watch -ebn 10 "$@"'
fi
