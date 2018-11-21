# clearsign files in a folder with sha256sum and gpg
alias clearsign-folder='find -type f -exec sha256sum {} \+ | gpg --clearsign'
  
