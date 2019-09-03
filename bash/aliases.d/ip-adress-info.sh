# netinfo - shows network information for your system
ipaddress () {
 local _grep="^[[:digit:]]\+:\|^[[:space:]]*\(link/\|inet\)"

 local _mac="[a-f0-9:]*"
 local _ipv4s="[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\/[0-9]\{1,3\}"
 local _ipv6s="$_mac\/[0-9]\{1,3\}"

 local _iface="s/^[[:digit:]]\+: \(.*\): <.*> .* state \(UP\|DOWN\|UNKNOWN\).*$/\n\1 (\2):/"
 local _link="s/link\/\(.* $_mac\) .*$/\1/"
 local _inet4="s/inet \($_ipv4s\) .*$/ipv4 \1/"
 local _inet6="s/inet6 \($_ipv6s\) .*$/ipv6 \1/"

 ip addr | grep -e "$_grep" | sed -e "$_iface" -e "$_link" -e "$_inet4" -e "$_inet6"

 echo
}
alias ipaddr='ipaddress'

# get public ip address information with wtfismyip.com
wtfismyip() {
  for type in ipv4 ipv6; do
    echo "$type:"
    local json=$(curl -s "https://$type.wtfismyip.com/json")
    [[ -z $json ]] && { echo "  err: no $type connectivity?"; continue; }
    sed -n \
      -e 's/.*"YourFuckingIPAddress": "\(.*\)",.*/  address: \1/p' \
      -e 's/.*"YourFuckingHostname": "\(.*\)",.*/  hostname: \1/p' \
      <<<"$json";
  done
}
alias publicip='wtfismyip'