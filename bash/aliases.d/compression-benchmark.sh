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
COMPRESSORS=("$@")
if [[ -z $COMPRESSORS ]]; then
  COMPRESSORS=(cat lz4 gzip bzip2 xz lzip)
fi

say() { printf '\033[1m%s\033[0m %s\n' "$1" "$2"; }

# output original file info
SIZE=$(wc -c <$FILE)
say "Original file:" "$FILE, $SIZE bytes"

for compressor in "${COMPRESSORS[@]}"; do
 
  say "Testing compressor:" "$compressor";
  if ! $compressor <<< 'Hello, World!' >/dev/null; then
    continue
  fi

  # runtime info in: $outputsize[Bytes] $runtime[seconds]
  run=$( (TIMEFORMAT='%3R'; time $compressor <$FILE | wc -c) 2>&1)
  o=$(echo $run | awk '{print $1}')
  t=$(echo $run | awk '{print $2}')

  # calculate compression ratio
  ratio=$(bc <<< "scale=3; $o / $SIZE")

  # calculate performance as ratio / time
  score=$(bc <<< "scale=3; $ratio / $t" 2>/dev/null)
  [[ -z $score ]] && score="∞";
  
  echo " time   : $t seconds";
  echo " output : $o Bytes";
  echo " ratio  : $ratio";
  echo " score  : $score";

done

}
