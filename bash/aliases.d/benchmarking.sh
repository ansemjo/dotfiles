#!/usr/bin/env bash

# check performance of various compressors on a file
compression-benchmark() {

  # first argument is the file to test on
  if [[ -z ${1+defined} ]] || ! [[ -f $1 ]] || ! [[ -r $1 ]]; then
    printf 'ERR: readable file required as argument: %q\n' "$1" >&2;
    printf 'usage: $ %s <file> [compressor [compressor]]\n' "${FUNCNAME[0]}" >&2;
    return 1;
  fi
  FILE=$1; shift 1;
  SIZE=$(wc -c <"$FILE")

  # remaining arguments are the compressors
  COMPRESSORS=("$@")
  if [[ ${#COMPRESSORS[@]} -eq 0 ]]; then
    # use defaults if none given
    COMPRESSORS=(cat gzip zstd xz)
  fi

  # print a header and function for result lines
  printf "| %10s | %10s | %14s | %8s | %8s |\n" Compressor Time Bytes Ratio Score
  printf "|------------|------------|----------------|----------|----------|\n"
  res() { printf "\r| %10s | %10s | %14s | %8s | %8s |\n" "$@"; }

  # print original file info
  res original "" "$SIZE" "1.000" ""

  # try all the compressors and print results
  for compressor in "${COMPRESSORS[@]}"; do
 
    # check if compressor works
    if ! $compressor <<< 'Hello, World!' >/dev/null; then continue; fi
    printf ' testing %s ...' "$compressor"

    # runtime info in: $outputsize[Bytes] $runtime[seconds]
    run=($( (TIMEFORMAT='%3R'; time $compressor <"$FILE" | wc -c) 2>&1))
    o=$(echo "${run[@]}" | awk '{print $1}')
    t=$(echo "${run[@]}" | awk '{print $2}')

    # calculate compression ratio
    ratio=$(bc -l <<< "scale=3; $o / $SIZE")

    # calculate an arbitrary performance metric
    # TODO: find a better calculation?
    # plot: https://www.wolframalpha.com/input/?i=3d+plot+ln(-ln(c)%2Fln(t%2B1)%2B1)+from+c%3D0.1..1,+t%3D0..10
    score=$(bc -l <<< "scale=3; l((-l($ratio)/l($t+1))+1)" 2>/dev/null)
    #score=$(bc -l <<< "scale=3; (-l($ratio)/l($t+1))+1" 2>/dev/null)
    if [[ -z $score ]]; then score="∞"; fi
  
    # print result
    res "$compressor" "$t" "$o" "$ratio" "$score"

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
