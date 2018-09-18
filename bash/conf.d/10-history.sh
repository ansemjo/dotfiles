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

# use hstr if available
if command -V hstr >/dev/null; then
  # bind to ctrl-r, use a space to ignore hstr command itself
  bind '"\C-r": "\C-a hstr -- \C-j"'
  # flush history to file
  export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
  # make it colorful
  export HSTR_CONFIG=hicolor
fi
