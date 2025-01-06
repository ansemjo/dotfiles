function cbwatch -d "continuosly monitor clipboard and output \0-separated"
    set -f last "" # remember the last element
    while true;
        set -f this (xclip -selection clipboard -out)
        if test "$this" != "$last";
            set -f last $this
            printf "%s\0" $this
        end
        sleep 0.5
    end
end
