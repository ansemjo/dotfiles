# add global yarn bin path to $PATH if yarn is installed
# check if common path exists first because yarn is slow
if command -v yarn >/dev/null; then
  if [[ -d ~/.yarn/bin ]]; then
    export PATH=~/.yarn/bin:$PATH
  else
    YARNPATH=$(yarn global bin 2>/dev/null)
    [[ $? -eq 0 ]] && export PATH=$YARNPATH:$PATH
  fi
fi
