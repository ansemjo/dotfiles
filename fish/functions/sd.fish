# rotate through a stack of directories with pushd; use popd to remove a dir.
# this is different than just calling pushd without an argument, which just
# toggles back and forth between the last two.
function sd -d "rotate through a stack of directories"
    set -q argv[1]; or set argv +1
    pushd $argv[1]
end
