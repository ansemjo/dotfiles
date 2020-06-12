#!/usr/bin/env bash

# usage information
usage() {
cat >&2 <<USAGE
usage: $ install.sh [-h] [-B] [-a] [-b] [-g] [-t] [-v]
  -h  : display usage information (this)
  -B  : create backups when overwriting during linking
  -a  : link ansible.cfg
  -b  : link bashrc
  -g  : link gitconfig
  -t  : link tmux.conf
  -v  : link vimrc
USAGE
}

# parse commandline options
while getopts 'hBabgtv' flag; do
  case "$flag" in
    h) usage; exit 0;;
    B) LNBACKUP=yes;;
    a) ANSIBLE=yes;;
    b) BASHRC=yes;;
    g) GITCONFIG=yes;;
    t) TMUX=yes;;
    v) VIMRC=yes;;
    \?) usage; exit 1;;
  esac
done

# find absolute path to this dotfiles directory
DOTFILES=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")

# try to detect distribution
detect-os() {
  if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    case " $ID $ID_LIKE " in
      *fedora*) echo FEDORA;;
      *debian*) echo DEBIAN;;
      *suse*)   echo SUSE;;
      *arch*)   echo ARCH;;
      *)        echo UNKNOWN;;
    esac
  else
    echo UNKNOWN
  fi
}
OS=$(detect-os)

# ---------------------------------------- #
link() { ln -sfv $([[ $LNBACKUP == yes ]] && echo '-b') "$@"; }

if [[ $ANSIBLE == yes ]]; then
  link "$DOTFILES/ansible/ansible.cfg" /etc/ansible/ansible.cfg
fi

if [[ $BASHRC == yes ]]; then
  BASHRC="$DOTFILES/bash/bashrc"
  case $OS in
    DEBIAN|SUSE|ARCH) link "$BASHRC" /etc/bash.bashrc;;
    *)                link "$BASHRC" /etc/bashrc;;
  esac
  link "$DOTFILES/bash/dot-bashrc" /etc/skel/.bashrc
fi

if [[ $GITCONFIG == yes ]]; then
  link "$DOTFILES/git/gitconfig" /etc/gitconfig
fi

if [[ $TMUX == yes ]]; then
  link "$DOTFILES/tmux/tmux.conf" /etc/tmux.conf
fi

if [[ $VIMRC == yes ]]; then
  VIMRC="$DOTFILES/vim/vimrc"
  case $OS in
    DEBIAN) link "$VIMRC" /etc/vim/vimrc;;
    *)      link "$VIMRC" /etc/vimrc;;
  esac
fi
