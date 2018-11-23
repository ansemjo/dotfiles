addlicense-MIT() {
  
  # author from git config
  author="$(git config user.name)"
  [[ -z $author ]] && { echo 'no user.name in git config' >&2; return 1; }

  # assemble strings
  sym="${1:-#}"
  year=$(date +%Y)
  string=$(printf '%s Copyright (c) %d %s\\n%s Licensed under the MIT License\\n' "$sym" "$year" "$author" "$sym")
  echo -e "$string" >&2

  # usage note
  echo "type filenames or pipe from a find(1) command ..." >&2

  # filename on stdin
  while read -r file; do
    sed -i "1i$string" "$file";
  done

cat <<LICENSE
MIT License

Copyright (c) $year $author

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
LICENSE

}
