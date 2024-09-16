function mkcd -d "mkdir and enter"

    # accept a single argument
    argparse --min-args 1 --max-args 1 -- $argv
    or return
    set -l d $argv[1]

    # warn if it exists, or create
    if test -d $d
        echo >&2 \
            (set_color --dim)"warning: $d exists already"(set_color normal)
    else
        mkdir -p $d
    end

    # switch into it
    cd $d

end
