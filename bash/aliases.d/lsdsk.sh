# list all disks with size and model
if iscommand lsblk; then
  alias lsdsk='lsblk -dpo NAME,MODEL,SIZE'
fi
