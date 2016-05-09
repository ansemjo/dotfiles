# make and enter
mkcd () {
  if [ ! -n "$1" ]; then
    echo "Enter a directory name"
  elif [ -d $1 ]; then
    echo "'$1' already exists"
  else
    mkdir $1 && cd $1
  fi
}

# make and enter a temporary directory
mkcdtmp () {
    cd $(mktemp -d) && pwd
}
