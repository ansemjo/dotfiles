# open nautilus here (if system is gnome)
if [ -x /usr/bin/nautilus ]; then
  alias here='nautilus -w "$PWD" &>/dev/null &'
fi
