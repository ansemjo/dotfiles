#!/usr/bin/env bash

# Usage:  update-mirrors [source]
# If no source is specified, '.pacnew' of the target is tried.

if [ -x /usr/bin/rankmirrors ]; then
  update-mirrors() {

    say() { printf '\e[1m# %s\e[0m\n' "$1"; };

    # decide on source file
    local target='/etc/pacman.d/mirrorlist';
    if [[ -n $1 ]]; then
      if [[ -f $1 ]]; then
        local mirrors=$1;
      else
        say "ERROR: $1 is not a file";
        return 2;
      fi
    else
      local pacnew="$target.pacnew";
      if [[ -f $pacnew ]]; then
        local mirrors=$pacnew;
      else
        say "ERROR: no source specified and $pacnew not a file";
        return 2;
      fi
    fi
    say "using $mirrors";

    # choose mirrors
    # sed/sort/uniq/sed ensures that for http+https mirrors, only https is ranked
    local country='(Worldwide|Germany)';
    local list=$(awk "/^## $country/{p=1;next} /^$/{p=0} p" "$mirrors" |\
      sed -e 's/^#//' -e 's/http:/httpz:/' | sort -k 3.7 | uniq -s 15 | sed 's/httpz:/http:/');
    say "ranking $(wc -l <<<$list) mirrors from ${country:-everywhere}";

    # rank mirrors
    local ranked=$(rankmirrors -n 15 - <<<$list);

    # replace
    say "replace previous mirrorlist";
    printf '# ranked on %s\n%s\n' "$(date)" "$ranked" | sudo tee "$target";

  };
fi
