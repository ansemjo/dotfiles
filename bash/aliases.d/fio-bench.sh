#!/usr/bin/env bash
if iscommand fio; then

  # a fio alias for commonly used quick benchmarks
  alias fio-bench='fio --name fio-bench --ioengine=libaio --bs=4k --numjobs=4 --runtime=60 --group_reporting --direct=1 --iodepth=32 --size=2G --rw=rw'

fi
