# some standards for slurm
if [ -x /usr/bin/slurm ]; then
  alias ifslurm='slurm -s -t foo -i eth0'
fi
