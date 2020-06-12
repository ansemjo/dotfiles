#!/usr/bin/env bash
# simplified alias for uget-gtk
if iscommand uget-gtk; then

  get() {

    # require running uget
    if ! pgrep uget-gtk >/dev/null; then
      echo "launch uget first!" >&2
      return 1
    fi

    # file url in $1
    local file=${1:?download url required}

    # where to put downloads
    local folder=~/Downloads

    # filename may optionally be given directly
    if [[ -n $2 ]]; then
      filename="$2"
    else
      read -r -p 'Enter filename: ' -e filename
    fi

    # add to queue
    uget-gtk --quiet --folder="$folder" --filename="$filename" "$file"

  }

fi
