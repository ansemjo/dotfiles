# update and then show upgrades
if [ -x /usr/bin/apt ]; then
    function upgrades {
        apt update
        echo "------"
        apt list --upgradable
    }
elif [ -x /usr/bin/pacman ]; then
    function upgrades {
        tmp=$(mktemp --directory --tmpdir pacman-check-upgrades-XXXXXX)
        echo "using temporary db at '${tmp:?}'"
        cp -r "/var/lib/pacman/sync" "$tmp"
        ln -s "/var/lib/pacman/local" "$tmp"
        fakeroot pacman -Sy --dbpath "$tmp"
        echo "------"
        pacman -Qu --dbpath "$tmp"
        rm -rf "$tmp"
    }
fi
