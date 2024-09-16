if status --is-interactive; and command -q nautilus

    function here -d "open nautilus at current pwd"
        nautilus -w $PWD &>/dev/null &
        disown $last_pid
    end

end
