# print color table
terminal-colors() {
  
  echo
  printf ' color escapes are \033[1m\\033[..;..m\033[0m\n'
  printf " values 30..37 are \e[34mforeground colors\e[m\n"
  printf " values 40..47 are \e[30;47mbackground colors\e[m\n"
  printf " value   1 gives a \e[1mbold-faced look\e[m\n"
  printf " while   0 resets to defaults\n"
  echo

  # print column  headers
  for bgc in 'fg ' 'bg:' {40..47}\ ; do printf '%4s ' "$bgc"; done
  echo

  # for every foreground ..
  for fgc in '00' {30..37}; do
    # print row header
    printf '%3s  ' "$fgc"
    # print text blocks
    for bgc in '' \;{40..47}; do printf '\e[%smte\e[1mxt\e[0m ' "$fgc$bgc"; done
    echo
  done
  echo

}
