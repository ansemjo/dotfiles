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
  printf "+------------+------------+----------------+----------+----------+\n"
  printf "| %10s | %10s | %14s | %8s | %8s |\n" Compressor Time Bytes Ratio Score
  printf "|------------|------------|----------------|----------|----------|\n"
  res() { printf "\r| %10s | %10s | %14s | %8s | %8s |\n" "$@"; }

  # print original file info
  res original "" "$SIZE" "1.000" ""

  # calculator for the arbitrary performance "score"
  # plot: https://www.wolframalpha.com/input/?i=3d+plot+100*e%5E%28-3*c%29*e%5E%28-0.3*t%29+from+c%3D0.1..1%2C+t%3D0..10
  metric() {
    # arguments:
    RATIO=$1
    TIME=$2
    # there are a few "tweaks":
    HIGH=100  # highest score
    SKEW=2    # factor between ratio and time weights
    MULT=3    # common multiplier, accellerating decrease of score
    bc -l <<< "scale=4; $HIGH * e(-$MULT*$SKEW*$RATIO) * e(-0.1*$MULT*$TIME)" 2>/dev/null
  }

  # print some bandwidth-limited transmission calculations
  t=$(bc -l <<< "scale=3; $SIZE / 32768")      # 256 kBit
  res "256 kbit/s" "$t" "$SIZE" "1.000" "$(metric 1 "$t")"
  t=$(bc -l <<< "scale=3; $SIZE / 2097152")    #  16 MiB
  res "16 Mbit/s" "$t" "$SIZE" "1.000" "$(metric 1 "$t")"
  t=$(bc -l <<< "scale=3; $SIZE / 134217728")  #   1 GiB
  res "1 Gbit/s" "$t" "$SIZE" "1.000" "$(metric 1 "$t")"
  printf "|------------|------------|----------------|----------|----------|\n"

  # try all the compressors and print results
  for compressor in "${COMPRESSORS[@]}"; do
 
    # check if compressor works
    if ! $compressor <<< 'Hello, World!' >/dev/null; then continue; fi
    printf ' testing %s ...' "$compressor"

    # runtime info in: $outputsize[Bytes] $runtime[seconds]
    run=($( (TIMEFORMAT='%3R'; time $compressor <"$FILE" | wc -c) 2>&1))
    o=$(echo "${run[@]}" | awk '{print $1}')
    t=$(echo "${run[@]}" | awk '{print $2}')

    # calculate compression ratio and performance metric
    ratio=$(bc -l <<< "scale=3; $o / $SIZE")
    score=$(metric "$ratio" "$t")
    if [[ -z $score ]]; then score="∞"; fi
  
    # print result
    res "$compressor" "$t" "$o" "$ratio" "$score"

  done
  
  # close the table with a footer
  printf "+------------+------------+----------------+----------+----------+\n"

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
