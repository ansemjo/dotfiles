# generate ula prefix
ipv6prefix() {
  gist="40667dd9ee072107ae75000d047a89a0";
  [[ ! -f /tmp/$gist.js ]] && \
    curl -s "https://gist.githubusercontent.com/ansemjo/$gist/raw/" -o "/tmp/$gist.js";
  node "/tmp/$gist.js" "$*"
}

