# chmod / chown recursive
alias chownr='sudo chown -R'		# recursive chown
alias chmodr='sudo chmod -R'		# recursive chmod

chmod-files-recursive() { find . -type f -print0 | xargs -0 chmod "$1"; }
chmod-dirs-recursive()  { find . -type d -print0 | xargs -0 chmod "$1"; }
