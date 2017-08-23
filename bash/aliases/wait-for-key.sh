# wait for any keypress
waitkey ()
{
  read -rsp $'Press any key to continue...\n' -n1 key
}
