# useful alias to compare two hashes with https://github.com/ansemjo/randomart.py
if iscommand randomart.py; then

  artcompare() {
    echo "Enter two hashes/strings/lines to compare ..."
    read left;   left=$(randomart.py <<<"$left");
    read right; right=$(randomart.py <<<"$right");
    if [[ $left == $right ]]; then
      printf '\033[32mThe inputs match.\n'
    else
      printf '\033[31;1mThe inputs differ!\033[0;31m\n';
    fi
    paste <(cat <<<"$left") <(cat <<<"$right");
    printf '\033[0m';
  }

fi
