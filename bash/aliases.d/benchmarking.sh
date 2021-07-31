#!/usr/bin/env bash

# check efficiency of various compressors on a file
compression-benchmark() {

  # parameters:
  #  $1  : file which to compress
  #  $2+ : list of compressors to use

  FILE=$1
  if [[ -z $FILE || ! -f $FILE ]]; then
    printf 'no such / not a file: %q\n' "$FILE" >&2;
    printf 'usage: $ %s testing-file [compressor [compressor]]\n' "${FUNCNAME[0]}" >&2;
    return 1;
  fi

  shift 1;
  COMPRESSORS=("$@")
  if [[ ${#COMPRESSORS[@]} -eq 0 ]]; then
    # use defaults if none given
    COMPRESSORS=(cat lz4 zstd gzip xz lzip)
  fi

  say() { printf '\033[1m%s\033[0m %s\n' "$1" "$2"; }

  # output original file info
  SIZE=$(wc -c <"$FILE")
  say "Original file:" "$FILE, $SIZE bytes"

  for compressor in "${COMPRESSORS[@]}"; do
 
    say "Testing compressor:" "$compressor";
    if ! $compressor <<< 'Hello, World!' >/dev/null; then
      continue
    fi

    # runtime info in: $outputsize[Bytes] $runtime[seconds]
    run=($( (TIMEFORMAT='%3R'; time $compressor <"$FILE" | wc -c) 2>&1))
    o=$(echo "${run[@]}" | awk '{print $1}')
    t=$(echo "${run[@]}" | awk '{print $2}')

    # calculate compression ratio
    ratio=$(bc -l <<< "scale=5; $o / $SIZE")

    # calculate performance metric
    # plot: https://www.wolframalpha.com/input/?i=3d+plot+ln(-ln(c)%2Fln(t%2B1)%2B1)+from+c%3D0.1..1,+t%3D0..10
    score=$(bc -l <<< "scale=3; l((-l($ratio)/l($t+1))+1)" 2>/dev/null)
    [[ -z $score ]] && score="∞";
  
    echo " time   : $t seconds";
    echo " output : $o Bytes";
    echo " ratio  : $ratio";
    echo " score  : $score";

  done

}


# alias for a useful general fio benchmark
if iscommand fio; then

  # a fio alias for commonly used quick benchmarks
  alias fio-bench='fio --name fio-bench --ioengine=libaio --bs=4k --numjobs=4 --runtime=60 --group_reporting --direct=1 --iodepth=32 --size=2G --rw=rw'

fi


# more detailed statistics with GNU time
if iscommand /usr/bin/time; then
  statistics() {
    /usr/bin/time -f "\n time\n  user %U\n  sys %S\n  elapsed %E\n  cpu %P\n\n memory\n  resident max %M kb\n  resident avg %t kb\n  major page faults (IO) %F\n  minor page faults (reclaim) %R\n  voluntary context switches (wait) %w\n  involuntary context switches %c" "$@";
  }
fi
