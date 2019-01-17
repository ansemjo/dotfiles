#!/usr/bin/env bash

# script by reddit.com/u/zfa, with modifications to allow piping
# https://old.reddit.com/r/netsec/comments/agrrig/troy_hunt_the_773_million_record_collection_1/ee9jenv/

haveibeenpwned() {

  printf '\033[1m%-40s %9s  %s\033[0m\n' 'sha1 hash' '# hits' 'password'
  while read -r password; do

    # calculate hash with uppercase hex
    pwhash=$(printf '%s' "${password}" | openssl sha1 | awk '{print $2}');
    prefix="${pwhash:0:5}"; suffix="${pwhash:5}";
  
    # check haveibeenpwned api
    if ! response=$(curl -s "https://api.pwnedpasswords.com/range/${prefix^^}") || [[ -z $response ]]; then
      printf '%-40s %9s  %s\n' "${prefix}" 'error' 'failed to receive response' >&2;
      continue
    fi
  
    # iterate over lines in response
    while read -r line; do
      # only first 35 chars of line is hash suffix
      if [ "${line:0:35}" == "${suffix^^}" ]; then
        result=($(echo "${prefix}${line,,}" | tr -d '\r' | cut -d: -f1,2 --output-delimiter=" "))
        printf '%-40s % 9d  %s\n' "${result[0]}" "${result[1]}" "${password}"
        continue
      fi
    done <<< "${response}"

  done

}
