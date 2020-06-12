#!/usr/bin/env bash
# pingscan, preferably show all active IPs on local network
pingscan () {
  if [[ -n $1 ]] && [[ $1 != -h ]]; then
    nmap -sn "$1" | grep ^Nmap | sed -e 's/Nmap scan report for //' -e 's/Nmap done: //'
  else
     echo "please specify a subnet like:  $ pingscan 192.168.0.*"
  fi
}
