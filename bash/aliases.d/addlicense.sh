addlicense-MIT() {
  
  # author from git config
  author="$(git config user.name)"
  [[ -z $author ]] && { echo 'no user.name!' >&2; return 1; }

  # assemble strings
  sym="${1:-#}"
  year=$(date +%Y)
  string=$(printf '%s Copyright (c) %d %s\\n%s Licensed under the MIT License\\n' "$sym" "$year" "$author" "$sym")
  echo -e "$string" >&2

  # filename on stdin
  while read file; do
    sed -i "1i$string" "$file";
  done

}
