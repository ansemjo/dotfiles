# output random characters from urandom
randomchar () {
  if [[ $1 =~ ^[0-9]+$ ]]; then
    n=$1; g=$2;
  else
    n=45; g=$1;
  fi
  </dev/urandom tr -dc "${g:-[:alnum:]_.~-}" | head -c$n;
  echo;
}

# output random hex characters from urandom
randomhex () {
  randomchar "${1:-32}" "a-f0-9";
}

# output a random mac address with possibility to define vendor part yourself
randommac () {
  _h() { randomhex 2; }
  vendor=$(_h):$(_h):$(_h);
  device=$(_h):$(_h):$(_h);
  mac="${1-$vendor}:$device";
  echo "${mac,,}";
  unset -f _h
}

# echo a random 10.0.0.0/8 ipv4
randomip() {
  _rndip() { shuf -i 1-254 -n 1; };
  echo "10.$(_rndip).$(_rndip).$(_rndip)";
  unset -f _rndip
}

# random semi-readable password
randompass() {
  _pad() { randomchar 4 ${1:-'a-zA-Z0-9#+*$%&?/'}; }
  echo -n "$(_pad "$1"):$(_pad "$1"):$(_pad "$1"):$(_pad "$1"):$(_pad "$1")";
  unset -f _pad
}

# random 32 byte key in base64 encoding
randomkey() {
  head -c 32 /dev/urandom | base64
}
