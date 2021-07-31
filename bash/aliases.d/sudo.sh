#!/usr/bin/env bash

# check command after sudo for aliases
alias sudo='sudo '

# quickly become root
alias suu='sudo su'

# grab ownership of a file or directory
grab() { sudo chown -R "${USER}" "${1:-.}"; }

# be polite
alias please=sudo
