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

# Set some defaults for the prompt line; defaults to 'no' if unset
    # use color? (yes/no)
    PS1_COLOURFUL=yes
    # show exit status of last command? (yes/no)
    PS1_EXITSTATUS=yes
    # display user name? (yes/no)
    PS1_USERNAME=yes
    # display hostname? (yes/no)
    PS1_HOSTNAME=yes
    # display current path? if yes, full or realtive only? (full/relative/no)
    PS1_PATHDISPLAY=full

    if [ -f ~/.bash_options ]; then
        . ~/.bash_options
    fi

# prompt_builder; is called after every command to refresh prompt
function prompt_builder {
    
    # get exit status of previously run command
    local _EXITSTATUS=$?

    PS1=""

    
    if [ "$PS1_COLOURFUL" = yes ]; then

        C_GREEN_BOLD='\[\e[01;32m\]'
        C_GREEN='\[\e[00;32m\]'
        C_RED_BOLD='\[\e[01;31m\]'
        C_RED='\[\e[00;31m\]'
        C_BLUE_BOLD='\[\e[01;34m\]'
        C_BLUE='\[\e[00;34m\]'
        C_YELLOW='\[\e[00;33m\]'
        C_NORMAL='\[\e[0m\]'
        C_BOLD='\[\e[1m\]'
        C_NORMAL_BOLD=$C_NORMAL$C_BOLD
        C_END='\[\e[m\]'

        if [ $PS1_COLOUR ]; then
            local _C_PROMPT=$PS1_COLOUR
        else
            if [ "`id -u`" -eq 0 ]; then
                local _C_PROMPT=$C_RED
            else
                local _C_PROMPT=$C_GREEN
            fi
        fi
    
    fi

    local _CROSS='\[\342\234\]\227'
    local _CHECK='\[\342\234\]\223'


# <exit status>
if [ "$PS1_EXITSTATUS" = yes ]; then
    if [[ $_EXITSTATUS -eq 0 ]] ; then
        PS1+="($C_GREEN_BOLD$_CHECK$C_END) "
    else
        PS1+="($C_RED_BOLD$_CROSS $_EXITSTATUS$C_END) "
    fi
fi

# <user>
if [ "$PS1_USERNAME" = yes ]; then
    PS1+="$_C_PROMPT\u$C_END"
fi

# @<hostname>
if [ "$PS1_HOSTNAME" = yes ]; then
    PS1+=" $C_NORMAL@$C_BOLD\h$C_END"
fi

# [<path>]
if [ "$PS1_PATHDISPLAY" = full ]; then
    PS1+=" $_C_PROMPT[\w]$C_END"
elif [ "$PS1_PATHDISPLAY" = relative ]; then
    PS1+=" $_C_PROMPT[\W]$C_END"
fi

# prompt symbol $/#
    PS1+="$C_NORMAL_BOLD\\$ $C_END$C_NORMAL"

}

PROMPT_COMMAND='prompt_builder'

# If this is an xterm set the window title too
case "$TERM" in
    xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
        PROMPT_COMMAND+='; echo -ne "\033]0;${USER} @${HOSTNAME} [${PWD}]\007"' ;;
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
