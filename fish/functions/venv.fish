# create a virtualenv
# TODO: check https://alexwlchan.net/2023/fish-venv/ for auto-activation
function venv --description "Create and activate a new virtual environment"
    # activate existing, if available
    for v in venv .venv
        if test -f $v/bin/activate.fish
            source $v/bin/activate.fish
            return
        end
    end
    # otherwise create a new one
    python3 -m venv .venv/
    source .venv/bin/activate.fish
end
