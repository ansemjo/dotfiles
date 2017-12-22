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
  h() { randomhex 2; }
  vendor=`h`:`h`:`h`;
  device=`h`:`h`:`h`;
  mac="${1-$vendor}:$device";
  echo "${mac,,}";
}
