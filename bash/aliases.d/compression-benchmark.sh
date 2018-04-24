#!/usr/bin/env bash

compression-benchmark() {

# parameters:
#  $1  : file which to compress
#  $2+ : list of compressors to use

FILE=$1
if [[ -z $FILE || ! -f $FILE ]]; then
  printf 'no such file: %q\n' "$FILE";
  exit 1;
fi

shift 1;
COMPRESSORS=$*
if [[ -z $COMPRESSORS ]]; then
  COMPRESSORS="cat lz4 gzip bzip2 xz lzip"
fi

say() { printf '\033[1m%s\033[0m %s\n' "$1" "$2"; }

# output original file info
SIZE=$(wc -c <$FILE)
say "Original file:" "$FILE, $SIZE bytes"

for compressor in $COMPRESSORS; do
 
  if ! command -v "$compressor" >/dev/null; then
    say "WARN" "command $compressor not found"
    continue
  fi
  say "Testing compressor:" "$compressor";

  # runtime info in: $runtime[sec] $memory[kB] $output[B]
  run=$( (/usr/bin/time -f '%e %M' $compressor <$FILE | wc -c) 2>&1)
  t=$(echo $run | awk '{print $1}')
  m=$(echo $run | awk '{print $2}')
  o=$(echo $run | awk '{print $3}')

  # calculate compression ratio
  ratio=$(bc <<< "scale=3; $o / $SIZE")

  # calculate performance as ratio / time
  score=$(bc <<< "scale=3; $ratio / $t" 2>/dev/null)
  [[ -z $score ]] && score="∞";
  
  echo " time   : $t seconds";
  echo " memory : $m kiloBytes";
  echo " output : $o Bytes";
  echo " ratio  : $ratio";
  echo " score  : $score";

done

}
