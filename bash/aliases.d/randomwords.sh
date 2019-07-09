#!/usr/bin/env bash

# function() scaffold for usage in aliases.d
words() {

# generate readable names of concatenated words
# examples: uptown_voucher, dresser_snowsuit, leopard_enactment
# IF(!) you trust shuf's randomness you COULD use this as a password generator

# use eff's short word list
WORDLIST="https://www.eff.org/files/2016/09/08/eff_short_wordlist_2_0.txt"

# other eff wordlists
#WORDLIST="https://www.eff.org/files/2016/09/08/eff_short_wordlist_1.txt"
#WORDLIST="https://www.eff.org/files/2016/07/18/eff_large_wordlist.txt"

# where to store wordlist
DIR=~/.cache/wordlists
WORDS="$DIR/$(basename $WORDLIST)"

# download list if it doesn't exist
if [[ ! -f $WORDS ]]; then
  echo "download wordlist $WORDLIST ..." >&2
  mkdir -p "$DIR"
  curl -Lo "$WORDS" "$WORDLIST";
fi

# function to get one word
word() { shuf -n1 "$WORDS" | awk '{print $2}'; }

# variables
n=${1:-2} # assemble n words, default 2
c=${2:-_} # concatenate with c, default _

# print words
array=($(for i in $(seq $n); do word; done))
printf "%s$c" "${array[@]}" | head -c-1
echo

# end function scaffold and add alias
}
alias randomwords=words
