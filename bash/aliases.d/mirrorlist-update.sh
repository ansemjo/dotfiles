if [ -x /usr/bin/rankmirrors ]; then
update-mirrorlist() {
    mirrors="/etc/pacman.d/mirrorlist"
    # select mirrors source file
    echo "--> selecting source file .."
    if [ -n "$1" ]; then
        # specified on cmdline
        if [ ! -f "$1" ]; then
            echo "--> no file '$1' exists"
            return 2
        fi
        source="$1"
    else
        # use mirrorlist.pacnew
        pacnew="${mirrors}.pacnew"
        if [ ! -f $pacnew ]; then
            echo "--> no source file specified and no mirrorlist.pacnew available"
            return 2
        fi
        source=$pacnew
    fi
    echo "--> using $source"
    # uncomment all Servers
    echo "--> uncomment Servers in source file"
    rnktmp=$(mktemp -t rankmirrors-temp-XXXXX)
    countries='Germany'
    echo "--> selectring ($countries)"
    sed -ne 's/^#Server/Server/'\
        -e "/$countries/,/^$/p"\
        "$source" > "$rnktmp"
    # run rankmirrors
    echo "--> running rankmirrors ..."
    rankmirrors -n 15 $rnktmp | tee $rnktmp.r
    echo "--> replace old mirrorlist"
    sudo mv $rnktmp.r $mirrors
    sudo chown root:root $mirrors
    rm -f "$rnktmp*"
}
fi
