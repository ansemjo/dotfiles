# use a rootless docker daemon, if it exists
if test -r $XDG_RUNTIME_DIR/docker.sock
    set -xg DOCKER_HOST unix://$XDG_RUNTIME_DIR/docker.sock
end
