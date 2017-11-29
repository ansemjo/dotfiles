# list all disks with size and model
if iscommand lsblk; then
  alias lsdsk='lsblk --nodeps --paths --output NAME,SIZE,VENDOR,MODEL,SERIAL,TYPE,TRAN --sort MODEL';
fi
