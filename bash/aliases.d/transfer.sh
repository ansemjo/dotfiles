# upload files to https://transfer.sh
# adapted from https://gist.github.com/nl5887/a511f172d3fb3cd0e42d
transfer() {
  
  # check argument
  if [[ -z $1 ]]; then
    printf 'usage: $ transfer filename.txt\n(filename is mandatory, contents can be piped)\n';
    return 1;
  fi

  # prepare
  link=$(mktemp --tmpdir transfer.XXXXXX)
  file=$1
  name=$(basename "$file" | sed 's/[^a-zA-Z0-9._-]/_/g')
  up() { curl --upload-file "$1" "https://transfer.sh/$name" > "$link"; }

  # upload from stdin if piped
  tty -s && up "$file" || up "-";
  echo "$(cat "$link")";
  rm -f $link;

}
