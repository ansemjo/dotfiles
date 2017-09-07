# screen orientation, mainly intended for use on a laptop
if [ -x /usr/bin/xrandr ]; then
  alias ori='xrandr -o'
  alias orio='xrandr -o normal'
fi
