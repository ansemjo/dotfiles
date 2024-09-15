#!/usr/bin/env bash

# more detailed statistics with GNU time
if iscommand /usr/bin/time; then
  statistics() {
    /usr/bin/time -f "\n time\n  user %U\n  sys %S\n  elapsed %E\n  cpu %P\n\n memory\n  resident max %M kb\n  resident avg %t kb\n  major page faults (IO) %F\n  minor page faults (reclaim) %R\n  voluntary context switches (wait) %w\n  involuntary context switches %c" "$@";
  }
fi
