# netinfo - shows network information for your system
ipaddr ()
{
 _grep="^[[:digit:]]\+:\|^[[:space:]]*\(link/\|inet\)"

 _mac="[a-f0-9:]*"
 _ipv4s="[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\/[0-9]\{1,3\}"
 _ipv6s="$_mac\/[0-9]\{1,3\}"

 _iface="s/^[[:digit:]]\+: \(.*\): <.*> .* state \(UP\|DOWN\|UNKNOWN\).*$/\n\1 (\2):/"
 _link="s/link\/\(.* $_mac\) .*$/\1/"
 _inet4="s/inet \($_ipv4s\) .*$/ipv4 \1/"
 _inet6="s/inet6 \($_ipv6s\) .*$/ipv6 \1/"

 ip addr | grep -e "$_grep" | sed -e "$_iface" -e "$_link" -e "$_inet4" -e "$_inet6"

 if [ "$1" == "public" ] && command -v curl &>/dev/null && command -v publicip &>/dev/null; then
   echo -e "\n"
   publicip
 fi
 echo
}

# get public ip addr with wtfismyip.com
publicip() {
    for x in 4 6; do
        echo -n "public ipv$x: "; curl -s https://ipv$x.wtfismyip.com/text || echo "error. no ipv$x?"
    done
}
