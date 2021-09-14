#!/usr/bin/env bash
if iscommand qrencode; then

# encode stdin and clipboard to qrcode on terminal
alias qr='qrencode -t UTF8'
qrclip() { clipboard | qrencode -t UTF8; }

# print a qrcode with wifi credentials
wifiqr() {
  usage() {
    echo "usage: $ wifiqr <ssid> [<psk>]"
    echo "  ssid   ssid or nmconnection name is required"
    echo "  psk    if psk is given, qr code is generated directly"
  }
  qrcode() { # 1:ssid, 2:psk
    echo "WIFI:S:$1;T:WPA;P:$2;;" | qrencode -t UTF8
  }

  # connection name or ssid is required
  if [[ -z ${1+defined} ]] || [[ $1 = -h ]]; then
    usage >&2; return 1
  else
    ssid="$1"
  fi

  # if psk is given, generate directly
  if [[ -n ${2+defined} ]]; then
    qrcode "$ssid" "$2"
    return $?
  fi

  # check if nmconnection is a wifi and get psk
  file="/etc/NetworkManager/system-connections/$ssid.nmconnection"
  if ! [[ -r $file ]]; then
    echo "err: file not readable: $file" >&2; return 1
  elif ! grep '^type=wifi$' "$file" >/dev/null; then
    echo "err: not a wifi connection: $file" >&2; return 1
  elif ! grep '^psk=' "$file" >/dev/null; then
    echo "err: psk field missing" >&2; return 1
  fi
  psk=$(sed -n "1,/^psk=/s/^psk=//p" "$file")
  qrcode "$ssid" "$psk"
  return $?

}


fi

if iscommand zbarcam; then
  # read qr and barcodes with webcam silently
  qrread() { zbarcam --raw --nodisplay; }
fi
