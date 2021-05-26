#!/usr/bin/env bash

if iscommand iw; then
wifiscan() {
  iw dev | awk '$1 == "Interface" { print $2 }' | xargs -IDEV sudo iw dev DEV scan | awk '
$0 ~ /^BSS/ {
  $0 = gensub(/BSS ([0-9a-f:]+)\(on ([^)]+)\)( -- (.*))?/, "\\2 \\1 \\4", "global", $0)
  dev = $1
  bss = $2
  ass = $3 != "" ? "*" : " "
}
$1 == "freq:" {
  frq = $2
}
$1 == "signal:" {
  sig = $2 " " $3
}
$1 == "SSID:" {
  $1 = ""
  printf("%s\t%s\t%.3f MHz\t%s\t%s%s\n", dev, bss, frq / 1000, sig, ass, $0)
}
'
}
fi
