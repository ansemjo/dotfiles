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

    # filename may optionally be given
    if [[ -n $2 ]]; then
      uget-gtk --quiet --folder="$folder" --filename="$2" "$file"
    else
      uget-gtk --quiet --folder="$folder" "$file"
    fi

  }

fi
