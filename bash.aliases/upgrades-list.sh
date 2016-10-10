# update and then show upgrades

if [[ -x /usr/bin/apt ]]; then
  
  # with apt, e.g. Debian, Ubuntu, ...
  function upgrades {
    apt update
    echo "------"
    apt list --upgradable
  }

elif [[ -x /usr/bin/pacman ]]; then
  
  # with pacman / pacaur, e.g. Arch ...
  function upgrades {

    # create tmp copy with user permissions
    tmp=$(mktemp --directory --tmpdir pacman-check-upgrades-XXXXXX)
    echo "using temporary db at '${tmp:?}'"
    cp -dR --preserve=all "/var/lib/pacman/sync" "$tmp"
    ln -s "/var/lib/pacman/local" "$tmp"

    # update db
    fakeroot pacman -Sy --dbpath "$tmp"

    # if pacaur is installed, display updates with it
    echo "------ Package updates:"
    if [[ -x /usr/bin/pacaur ]]; then
      pacaur -Qu -- --dbpath "$tmp"
      echo "------ AUR package updates:"
      pacaur -k
    else
      pacman -Qu --dbpath "$tmp"
    fi

    # cleanup temporary db
    rm -rf "$tmp"
  }

fi
