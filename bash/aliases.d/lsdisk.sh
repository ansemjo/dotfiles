#!/usr/bin/env bash
# list all disks with size and model
if iscommand lsblk; then
  alias lsdisk='lsblk --nodeps --paths --output NAME,SIZE,VENDOR,MODEL,SERIAL,TYPE,TRAN';
fi
