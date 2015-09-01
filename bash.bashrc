# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then

	BGREEN='\[\033[1;32m\]'
	GREEN='\[\033[0;32m\]'
	BRED='\[\033[1;31m\]'
	RED='\[\033[0;31m\]'
	BBLUE='\[\033[1;34m\]'
	BLUE='\[\033[0;34m\]'
	NORMAL='\[\033[00m\]'
	
	
    # using http://bashrcgenerator.com/ to generate the PS1='' lines:
    if [ "`id -u`" -eq 0 ]; then
	# root in RED
	PS1='${debian_chroot:+($debian_chroot)}\[$(tput bold)\]\[\033[38;5;8m\]>>> \[\033[38;5;9m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\] @\[$(tput bold)\]\h\[$(tput sgr0)\] \[\033[38;5;1m\][\w]\[$(tput bold)\]\[\033[38;5;15m\]\\$\[$(tput sgr0)\] '
    else
	# normal user in GREEN
	PS1='${debian_chroot:+($debian_chroot)}\[$(tput bold)\]\[\033[38;5;8m\]>>> \[\033[38;5;10m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\] @\[$(tput bold)\]\h\[$(tput sgr0)\] \[\033[38;5;2m\][\w]\[$(tput bold)\]\[\033[38;5;15m\]\\$\[$(tput sgr0)\] '
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
    ;;
*)
    ;;
esac

# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# sudo hint
if [ ! -e "$HOME/.sudo_as_admin_successful" ] && [ ! -e "$HOME/.hushlogin" ] ; then
    case " $(groups) " in *\ admin\ *|*\ sudo\ *)
    if [ -x /usr/bin/sudo ]; then
	cat <<-EOF
	To run a command as administrator (user "root"), use "sudo <command>".
	See "man sudo_root" for details.
	
	EOF
    fi
    esac
fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
	function command_not_found_handle {
	        # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
		   /usr/lib/command-not-found -- "$1"
                   return $?
                elif [ -x /usr/share/command-not-found/command-not-found ]; then
		   /usr/share/command-not-found/command-not-found -- "$1"
                   return $?
		else
		   printf "%s: command not found\n" "$1" >&2
		   return 127
		fi
	}
fi


if [ -f /etc/bash.aliases ]; then
    . /etc/bash.aliases
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
