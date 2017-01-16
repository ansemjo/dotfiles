# some sudo shorthands
alias sudo='sudo '          # check command after sudo for aliases too
alias si='sudo vi'			# root vim editor
alias sedit='gksudo gedit' # launch gedit with root privileges
alias suu='sudo su'			# become root
alias runlevel='sudo /sbin/init'	# change current runlevel
grab() {
  sudo chown -R ${USER} ${1:-.}		# grab ownership
}
