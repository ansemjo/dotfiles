# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# enlarge history
HISTSIZE=
HISTFILESIZE=10000

# timestamp display for history file
HISTTIMEFORMAT="[%F %T] "

# append to the history file, don't overwrite it
shopt -s histappend

# save multiline commands in .. literally multiple lines
shopt -s lithist
