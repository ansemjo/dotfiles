#!/usr/bin/env bash

# reencrypt and wrap a file into an encrypted luks container by truncating file a little
luksify() {
  file=${1:?file required}; size=${2:-16};
  (
    set -xe;
    truncate -s +"$((2*size))M" "${file}";
    cryptsetup -yq reencrypt --encrypt --type luks2 --resilience none --disable-locks --reduce-device-size "$((2*size))M" "${file}";
    truncate -s -"${size}M" "${file}";
  );
}

