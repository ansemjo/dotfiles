#!/usr/bin/env bash

# rankmirrors is included in the pacman-contrib package
if [[ -x /usr/bin/rankmirrors ]]; then
  update-mirrorlist() {
    (
    set -e
    say() { printf '%s\n' "$*" >&2; };

    # https://wiki.archlinux.org/index.php/Mirrors#Fetching_and_ranking_a_live_mirror_list
    say "fetch updated mirrorlist: DE/https/status=on ..."
    local mirrors
    mirrors=$(curl -sL "https://archlinux.org/mirrorlist/?country=DE&protocol=https&use_mirror_status=on" |\
      sed -e 's/^#Server/Server/' -e '/^#/d')

    say "rank mirrors ..."
    local ranked
    ranked=$(rankmirrors -n 10 - <<<"$mirrors")

    local list="/etc/pacman.d/mirrorlist"
    say "replace $list ..."
    printf "# ranked on %s\n%s\n" "$(date)" "$ranked" | sudo tee "$list"
    )
  };
fi

# read archlinux news
archnews() {
# Credit belongs here:
# https://bbs.archlinux.org/viewtopic.php?pid=1145058#p1145058
  (
    set -e

    # Set the feed
    local feed
    if [ -z "$1" ]; then
        # Arch Linux News by default
        feed="https://www.archlinux.org/feeds/news/";
    else
        feed="$1";
    fi
    
    # Get the feed
    local rss_source
    rss_source="$(curl --silent "$feed" | sed -e ':a;N;$!ba;s/\n/ /g')";
    
    # Display the feed
    if [ -z "$rss_source" ]; then
        echo "The feed is empty";
        return 1;
    fi
    
    # The characters "£, §" are used as metacharacters. They should not be encountered in a feed...
    echo -e "$(echo "$rss_source" | \
    sed -e 's/&amp;/\&/g
    s/&lt;\|&#60;/</g
    s/&gt;\|&#62;/>/g
    s/<\/a>/£/g
    s/href\=\"/§/g
    s/<title>/\\n\\n\\n   :: \\e[01;31m/g; s/<\/title>/\\e[00m ::\\n/g
    s/<link>/ [ \\e[01;36m/g; s/<\/link>/\\e[00m ]/g
    s/<description>/\\n\\n\\e[00;37m/g; s/<\/description>/\\e[00m\\n\\n/g
    s/<p\( [^>]*\)\?>\|<br\s*\/\?>/\n/g
    s/<b\( [^>]*\)\?>\|<strong\( [^>]*\)\?>/\\e[01;30m/g; s/<\/b>\|<\/strong>/\\e[00;37m/g
    s/<i\( [^>]*\)\?>\|<em\( [^>]*\)\?>/\\e[41;37m/g; s/<\/i>\|<\/em>/\\e[00;37m/g
    s/<u\( [^>]*\)\?>/\\e[4;37m/g; s/<\/u>/\\e[00;37m/g
    s/<code\( [^>]*\)\?>/\\e[00m/g; s/<\/code>/\\e[00;37m/g
    s/<a[^§]*§\([^\"]*\)\"[^>]*>\([^£]*\)[^£]*£/\\e[01;31m\2\\e[00;37m \\e[01;34m[\\e[00;37m \\e[04m\1\\e[00;37m\\e[01;34m ]\\e[00;37m/g
    s/<li\( [^>]*\)\?>/\n \\e[01;34m*\\e[00;37m /g
    s/<!\[CDATA\[\|\]\]>//g
    s/\|>\s*<//g
    s/ *<[^>]\+> */ /g
    s/[<>£§]//g')\n\n" | \
    less -r;
    # Pipe that shit to a pager ...
  )
}
