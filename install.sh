#!/usr/bin/env bash

# usage information
usage() {
cat >&2 <<USAGE
usage: $ install.sh [-h] [-B] [-a] [-b] [-g] [-t] [-v] [-f]
  -h  : display usage information (this)
  -B  : create backups when overwriting during linking
  -a  : link ansible.cfg
  -b  : link bashrc
  -g  : link gitconfig
  -t  : link tmux.conf
  -v  : link vimrc
  -f  : link fish

example: quickly install fish, tmux, git, and vim links
  ./install.sh -ftgv
USAGE
}

# try to detect distribution
detect-os() {
  if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    case " $ID $ID_LIKE " in
      *fedora*) echo FEDORA;;
      *debian*) echo DEBIAN;;
      *suse*)   echo SUSE;;
      *arch*)   echo ARCH;;
      *gentoo*) echo GENTOO;;
      *)        echo UNKNOWN;;
    esac
  else
    echo UNKNOWN
  fi
}
OS=$(detect-os)
echo "detected distribution: ${OS,,}"

# parse commandline options
while getopts 'hBabgtvf' flag; do
  case "$flag" in
    h) usage; exit 0;;
    B) LNBACKUP=yes;;
    a) ANSIBLE=yes;;
    b) BASHRC=yes;;
    g) GITCONFIG=yes;;
    t) TMUX=yes;;
    v) VIMRC=yes;;
    f) FISH=yes;;
    \?) usage; exit 1;;
  esac
done

# complain if nothing given
if [[ $OPTIND -eq 1 ]]; then
  echo "err: no flags given" >&2
  usage
  exit 1
fi

# find absolute path to this dotfiles directory
DOTFILES=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")

# ---------------------------------------- #
lnargs=(-s -f -v)
if [[ $LNBACKUP == yes ]]; then lnargs+=(-b); fi
link() { ln "${lnargs[@]}" "$@"; }

if [[ $ANSIBLE == yes ]]; then
  link "$DOTFILES/ansible/ansible.cfg" /etc/ansible/ansible.cfg
fi

if [[ $BASHRC == yes ]]; then
  BASHRC="$DOTFILES/bash/bashrc"
  case $OS in
    DEBIAN|SUSE|ARCH) link "$BASHRC" /etc/bash.bashrc;;
    GENTOO)           link "$BASHRC" /etc/bash/bashrc;;
    *)                link "$BASHRC" /etc/bashrc;;
  esac
  link "$DOTFILES/bash/dot-bashrc" /etc/skel/.bashrc
fi

if [[ $FISH == yes ]]; then
  for dir in completions conf.d functions; do
    if [[ -d /etc/fish/$dir ]] && ! [[ -L /etc/fish/$dir ]]; then
      rmdir -v "/etc/fish/$dir"
      link "$DOTFILES/fish/$dir/" /etc/fish/$dir
    fi
  done
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
    DEBIAN|GENTOO)  link "$VIMRC" /etc/vim/vimrc;;
    *)              link "$VIMRC" /etc/vimrc;;
  esac
fi
