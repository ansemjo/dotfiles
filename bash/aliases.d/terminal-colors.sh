# print color table
terminal-colors() {
  
  printf "color escapes are %s\n" '\e[${value};...;${value}m'
  printf "values 30..37 are \e[33mforeground colors\e[m\n"
  printf "values 40..47 are \e[43mbackground colors\e[m\n"
  printf "value  1 gives a  \e[1mbold-faced look\e[m  i.e. \e[1;32m\\\e[1;32m\e[0m\n"
  printf "in the following table 'te' is normal and 'xt' is bold\n\n"

  for fgc in '00' {30..37}; do
    for bgc in '' \;{40..47}; do
      esc="$fgc$bgc"
      printf '%s: \e[%smte\e[1mxt\e[0m ' "$esc" "$esc"
    done
    printf '\n';
  done

}
