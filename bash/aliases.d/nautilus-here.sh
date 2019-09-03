# open nautilus here (if system is gnome)
if iscommand nautilus; then
  alias here='nautilus -w "$PWD" &>/dev/null &'
fi
