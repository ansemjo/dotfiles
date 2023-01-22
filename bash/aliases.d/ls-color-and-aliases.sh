#!/usr/bin/env bash
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	if test -r ~/.dircolors; then
    eval "$(dircolors -b ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi
fi

alias ls='ls --color=auto --group-directories-first'
alias dir='dir --color=auto --group-directories-first'
alias vdir='vdir --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# some ls aliases
alias l='ls -1F'	# one file per line
alias ll='ls -lF'	# long, classify
alias lla='ls -alF'	# all, long, classify; pretty verbose
alias la='ls -AF'	# almost all; like ls, but with .dot

# tree view
if iscommand tree; then
  alias lll='tree -pugF' # using dedicated tree command
else
  alias lll='ls -lARF'	# dirlist, generates huge output for many subfolders!
fi

# use exa if available
if iscommand exa; then
  alias ls='exa --group-directories-first'
fi
