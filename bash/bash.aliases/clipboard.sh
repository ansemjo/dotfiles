#!/bin/sh

# a simple way to fill the xclipboard or paste from it,
# to push content between a terminal and gui programs

# when there is something 'non-tty' on fd 0, i.e. stdin,
# then assume we are receiving content and put it into clipboard
# otherwise output what is currently inside

clipboard() {

  alias xclip='xclip -selection clipboard'

  if [ -t 0 ]; then
    xclip -out
  else
    xclip -in
  fi

}
