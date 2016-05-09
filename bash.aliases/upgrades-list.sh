# update and then show upgrades
if [ -x /usr/bin/apt ]; then
    alias upgrades='apt update && echo "------" && apt list --upgradable'
elif [ -x /usr/bin/pacman ]; then
    alias upgrades='pacman -Sy && echo "------" && pacman -Qu'
fi
