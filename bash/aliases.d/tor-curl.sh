# make a curl request through tor
tor-curl() {
  # check if tor is running and socks proxy is listening
  if pgrep -x tor >/dev/null && ss -Hlt '( sport = 9150 )' | grep '^LISTEN' >/dev/null; then
    curl --socks5-hostname localhost:9150 "$@";
  else
    printf 'Tor SOCKS5 proxy does not appear to be running.\n';
    return 1;
  fi
}
