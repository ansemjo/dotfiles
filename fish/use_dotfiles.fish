#!/usr/bin/env fish
# use this configuration directory for fish
# symlink this file in /etc/fish/conf.d/ globally

# find the directory name of the actual dotfiles
set -l dotfiles (dirname (readlink -f (status --current-filename)))

# add functions and completions, assume the /etc/fish is the second path in variable
set fish_function_path $fish_function_path[1] $dotfiles/functions/   $fish_function_path[2..]
set fish_complete_path $fish_complete_path[1] $dotfiles/completions/ $fish_complete_path[2..]

# source the configuration files in conf.d/
for conf in $dotfiles/conf.d/*.fish
  source $conf
end
