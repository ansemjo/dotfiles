#!/usr/bin/env bash
# a few scripts to adjust amplification levels on inputs or the white balance on cameras

# ---------- sound devices ---------- #

# set some amplification on a microphone / source
amplification() {
  usage() { printf '%s\n' 'usage: amplification <source> [<level>]' >&2; }
  # get source from first arg
  if [[ -z ${1+undefined} ]]; then usage; return 1; fi
  SOURCE="alsa_input.$1"
  # no $2 argument --> show current
  if [[ -z ${2+undefined} ]]; then
    pactl list sources | grep -B2 -A15 "$SOURCE" | awk '$1 ~ /(Description|Mute|Volume):/ { $1=$1; print $0 }'
  else
    pactl set-source-volume "$SOURCE" "$2"
  fi
}
_amplification() {
  # shellcheck disable=SC2034
  local cur prev words cword sources
  _init_completion || return
  # find connected alsa inputs
  sources=$(pactl list sources | awk '$1 == "Name:" && $2 ~ /^alsa_input\./ { gsub(/^alsa_input\./, "", $2); print $2 }')
  if [[ $cword -eq 1 ]]; then
    COMPREPLY=($(compgen -W "$sources" -- "$cur"))
  else
    COMPREPLY=()
  fi
}
complete -F _amplification amplification


# ---------- video devices ---------- #

# webcam notes:
#
# setting the white balance manually
# $ v4l2-ctl -d /dev/video3 --set-ctrl=white_balance_temperature_auto=0
# $ v4l2-ctl -d /dev/video3 --set-ctrl=white_balance_temperature=2800
#
# list current settings etc.
# $ v4l2-ctl -d /dev/video3 --list-formats
# $ v4l2-ctl -d /dev/video3 --get-fmt-video
#
# deauth / disable a device
# $ echo 0 | sudo tee /sys/class/video4linux/video0/device/authorized

# find the logitech cam device
logicam() {
  for dir in /sys/class/video4linux/video*; do
    if [[ $(cat "$dir/name") == 'Logitech Webcam C925e' ]] \
    && [[ $(cat "$dir/index") -eq 0 ]]; then
      echo "/dev/$(basename "$dir")"
      return 0
    fi
  done
}

# set manual whitebalance on my camera
whitebalance() {
  usage() { printf '%s\n' 'usage: whitebalance <device> [ auto | temp in K ]' >&2; }
  show() {
    v4l2-ctl -d "$1" --get-ctrl=white_balance_temperature_auto
    v4l2-ctl -d "$1" --get-ctrl=white_balance_temperature
  }
  # get video device from first arg
  if [[ -z ${1+undefined} ]]; then usage; return 1; fi
  DEVICE=$1
  if [[ -z ${2+undefined} ]]; then
    show "$DEVICE"
  else
    case "$2" in
      auto) # reset to auto
        v4l2-ctl -d "$DEVICE" --set-ctrl=white_balance_temperature_auto=1 ;;
      *[!0-9]*) # invalid / not a number
        usage; return 1 ;;
      *) # disable auto and set temp
        v4l2-ctl -d "$DEVICE" --set-ctrl=white_balance_temperature_auto=0
        v4l2-ctl -d "$DEVICE" --set-ctrl=white_balance_temperature="$2" ;;
    esac
    show "$DEVICE"
  fi
}
_whitebalance() {
  # shellcheck disable=SC2034
  local cur prev words cword devices
  _init_completion || return
  # find video camera inputs
  devices=(/dev/video*)
  case "$cword" in
    1) COMPREPLY=($(compgen -W "${devices[*]}" -- "$cur")) ;;
    2) COMPREPLY=($(compgen -W "auto 2500 4000 4500 6600" -- "$cur")) ;;
    *) COMPREPLY=() ;;
  esac
}
complete -F _whitebalance whitebalance




