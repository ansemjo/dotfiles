#!/usr/bin/env bash

# mount a local filesystem remotely with dpipe and sshfs slave mode
# TODO: implement -o opts argument for remote sshfs options
reversefs() {

  err() { echo "err: $*" 1>&2; usage; }

usage() { cat <<README
$ reversefs [...] user@hostname [localpath] remotepath
Mount a local filesystem path on a remote machine with a reverse sshfs setup.

  -h    display this help
  -r    run local sftp-server in read-only mode
  -v    verbose logging level for sftp-server

  user@hostname   ssh spec, use a config alias if you need options
  localpath       local path to mount remotely, \$PWD if none given
  remotepath      where to mount filesystem remotely

README
}

  # commandline parser
  local READONLY="false";
  local VERBOSE="false";
  local opt OPTIND;
  while getopts "rvh" opt; do
    case "$opt" in
      h) usage; return 0;;
      r) READONLY="true";;
      v) VERBOSE="true";;
      *) usage; return 1;;
    esac
  done
  shift "$((OPTIND-1))"

  # check number of required arguments
  if [[ $# -lt 2 ]] || [[ $# -gt 3 ]]; then
    err "not enough or too many arguments"
    return 1
  fi

  # use current local dir if none given
  if [[ $# -eq 2 ]]; then
    set "$1" "$PWD" "$2";
  fi

  # find sftp-server
  local SFTPSERVER
  local SFTPSERVERS=(
    /usr/lib/ssh/sftp-server
    /usr/lib/openssh/sftp-server
  )
  for s in "${SFTPSERVERS[@]}"; do
    if [[ -x $s ]]; then
      SFTPSERVER="$s";
      break
    fi
  done
  if [[ -z $SFTPSERVER ]]; then
    err "could not find sftp-server binary"
    return 1
  fi

  # run the actual command
  # shellcheck disable=SC2046
  dpipe "$SFTPSERVER" -e \
    $([[ $READONLY == true ]] && echo -R) \
    $([[ $VERBOSE == true ]] && echo -l VERBOSE) \
    = ssh "$1" sshfs :"$2" "$3" -o slave

}
_reversefs() {
  if iscommand _ssh; then
    _ssh
  else
    # shellcheck disable=SC2034
    local cur prev words cword
    _init_completion || return
    _known_hosts_real -a -- "$cur"
  fi
}
complete -F _reversefs reversefs

# add shorter alias if free
if ! iscommand rfs; then
  alias rfs=reversefs
  complete -F _reversefs rfs
fi
