# bashrc file for interactive bash(1) shells.

# If not running interactively, don't do anything
[[ $- != *i* ]] && return;

# get real directory of this file (follow symlinks)
BASH_DOTFILES="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")" )"

# load configuration and aliases
for rc in "$BASH_DOTFILES"/{conf,aliases}.d /etc/bashrc.d; do

  if [[ -d $rc ]]; then
    for file in "$rc"/*.sh; do
      if [[ -r $file ]]; then
        source "$file";
      fi
    done
  fi

done

# load user aliases
[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases;
