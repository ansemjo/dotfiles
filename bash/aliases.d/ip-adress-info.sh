# show ip addresses more readably
ipaddress () {
  ip addr | sed -n \
    -e "s/^[0-9]\+: \(.*\): <.*>/\n$(printf '\033[1m\\1\033[0m'): +/;s/+ .* master \([^ ]\+\)/[\1] +/;s/+\( .*\)\? state \([^ ]\+\) .*/\2/p" \
    -e "s/link\/\(\w\+ [0-9a-f:]\+\).*/\1/p" \
    -e "s/inet \([^ ]\+\).*/ipv4 \1/p" \
    -e "s/inet6 \([^ ]\+\).*/ipv6 \1/p";
  echo;
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
