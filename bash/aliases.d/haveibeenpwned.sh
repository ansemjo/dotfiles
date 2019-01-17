#!/usr/bin/env bash

# script by reddit.com/u/zfa, with modifications to allow piping
# https://old.reddit.com/r/netsec/comments/agrrig/troy_hunt_the_773_million_record_collection_1/ee9jenv/

haveibeenpwned() {

  printf '\033[1m%-40s\t%9s\t%s\033[0m\n' 'sha1 hash' '# hits' 'password'
  while read -r password; do

    # calculate hash with uppercase hex
    pwhash=$(printf '%s' "${password}" | openssl sha1 | awk '{print $2}');
    prefix="${pwhash:0:5}"; suffix="${pwhash:5}";
  
    # check haveibeenpwned api
    response=$(curl -s "https://api.pwnedpasswords.com/range/${prefix^^}");
    if [[ $? -ne 0 ]] || [[ -z $response ]]; then
      printf '%-40s\terror\tfailed to receive response\n' "${prefix}" >&2;
      continue
    fi
  
    # iterate over lines in response
    while read -r line; do
      # only first 35 chars of line is hash suffix
      if [ "${line:0:35}" == "${suffix^^}" ]; then
        printf '%-40s\t% 9d\t%s\n' $(echo "${prefix}${line,,}" | tr -d '\r' | cut -d: -f1,2 --output-delimiter=" ") "${password}"
        continue
      fi
    done <<< "${response}"

  done

}
