# use config files in ~/.config, if it exists
if test -d ~/.config/docker/
    set -xg DOCKER_CONFIG ~/.config/docker/
end
