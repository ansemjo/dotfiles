# output random alphanumeric characters from urandom
randomchar () {
  if [[ $1 =~ ^[0-9]+$ ]]; then
    # if the first arg is a number, use for n
    local n=$1; local chars=$2;
  else
    # otherwise use default n and assume it's a character class
    local n=42; local chars=$1;
  fi
  tr -dc "${chars:-[:alnum:]}" </dev/urandom | head -c"$n";
  # print final newline if output is a terminal
  [[ -t 1 ]] && echo;
}

# output random hex characters from urandom
randomhex () { randomchar "${1:-32}" "a-f0-9"; }

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

# random 32 byte key in base64 encoding
randomkey() { head -c 32 /dev/urandom | base64; }

# simple coinflip. heads or tails.
coinflip() {
  # get one random byte as unsigned int modulo 2
  local flip=$(( $(head -c1 /dev/urandom | od -t u1 -An) % 2 ))
  if [[ -n $1 && -n $2 ]]; then
    [[ $flip -eq 1 ]] && echo "$1" || echo "$2"
  else
    [[ $flip -eq 1 ]] && echo heads || echo tails
  fi
}

# quasi diceware password generator
randomwords() {

  # generate readable names of concatenated words from eff wordlist
  # examples: uptown_voucher, dresser_snowsuit, leopard_enactment
  # IF(!) you trust shuf's randomness you COULD use this as a password generator

  # use eff's short word list
  local WORDLIST="https://www.eff.org/files/2016/09/08/eff_short_wordlist_2_0.txt"

  # other eff wordlists
  #WORDLIST="https://www.eff.org/files/2016/09/08/eff_short_wordlist_1.txt"
  #WORDLIST="https://www.eff.org/files/2016/07/18/eff_large_wordlist.txt"

  # where to store wordlist
  local DIR=~/.cache/wordlists
  local WORDS="$DIR/$(basename $WORDLIST)"

  # download list if it doesn't exist
  if [[ ! -f $WORDS ]]; then
    echo "download wordlist $WORDLIST ..." >&2
    mkdir -p "$DIR" || return 1
    curl -# -Lo "$WORDS" "$WORDLIST" || return 1
  fi

  # function to get one word
  word() { shuf -n1 "$WORDS" | awk '{print $2}'; }

  # variables
  n=${1:-6} # assemble n words, default 2
  c=${2:- } # concatenate with c, default _

  # print words
  array=($(for i in $(seq $n); do word; done))
  printf "%s$c" "${array[@]}" | head -c-1
  echo

}

# random ICU star name
randomstar () {
  local stars=https://www.pas.rochester.edu/~emamajek/WGSN/IAU-CSN.txt
  local file=~/.cache/wordlists/star-names-IAU-CSN.txt
  if [[ ! -f $file ]]; then
    echo "download starlist $stars ..."
    mkdir -p "$(dirname "$file")" || return 1
    curl -# -Lo "$file" "$stars" || return 1
  fi
  grep '^[a-zA-Z]\+ ' "$file" | cut -d\  -f1 | uniq | shuf -n1;
}
