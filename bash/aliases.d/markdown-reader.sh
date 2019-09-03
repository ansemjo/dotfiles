# read markdown files
if iscommand pandoc; then
  markman() {
    pandoc -s -f markdown -t man "${1:?filename required}" \
      -M header="$(basename "$1")" \
      -M footer="$(readlink -f "$1")" \
    | man -l -
  }
fi
