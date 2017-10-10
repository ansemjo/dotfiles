# chmod all files/directories recursively
chmod-recursive-files()       { find "${2:-.}" -type f -print0 | xargs -0 chmod "$1"; }
chmod-recursive-directories() { find "${2:-.}" -type d -print0 | xargs -0 chmod "$1"; }
