# provide a simple function to clean up ssh multiplexing sockets
# for usage with ssh config 'ControlPath /run/user/%i/sshmux-%r@%h:%p.sock'
SSHMUX_GLOB="/run/user/$EUID/sshmux-*.sock"
muxclean () {
  local g="$SSHMUX_GLOB"
  if [[ -z $1 ]]; then
    echo "\$ $0 (all / user@host:port)" >&2 && return 1
  elif [[ $1 == all ]]; then
    rm -Iv $g
  else
    mux="${g%%\**}$1${g##*\*}"
    if [[ -S $mux ]]; then
      rm -fv "$mux"
    else
      echo "no such mux: $mux" >&2 && return 1
    fi
  fi
}

_muxlist () {
  local g="$SSHMUX_GLOB"
  for f in $g; do
    if [[ "$f" != "$g" && $f =~ ${g%%\**}(.*)${g##*\*} ]]; then
      echo "${BASH_REMATCH[1]}"
    fi
  done
}

_muxclean () {
  local cur prev words cword
  _init_completion || return
  [[ ${#words[@]} -gt 2 ]] && return
  local list=$(_muxlist)
  [[ -z $list ]] \
    && echo "no ssh muxes found for $SSHMUX_GLOB" \
    || list="all $list"
  COMPREPLY=($(compgen -W "$list" "$cur"))
}

complete -F _muxclean muxclean
