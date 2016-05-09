# read markdown files
if [ -x /usr/bin/pandoc ]; then
markman() {
    pandoc -s -f markdown -t man "$1" | man -l -
}; fi
