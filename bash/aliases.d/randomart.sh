#!/usr/bin/env bash
# useful alias to compare two hashes with https://github.com/ansemjo/randomart.py
if iscommand randomart.py; then

  artcompare() {
    echo "Enter two hashes/strings/lines to compare ..."
    read -r left;   left=$(randomart.py <<<"$left");
    read -r right; right=$(randomart.py <<<"$right");
    paste <(cat <<<"$left") <(cat <<<"$right");
    if [[ "$left" == "$right" ]]; then
      printf '\033[32mThe inputs match.\033[0m\n'
    else
      printf '\033[31;1mThe inputs differ!\033[0m\n';
    fi
  }

fi
