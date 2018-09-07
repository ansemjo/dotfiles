# just add ~/.local/bin .. this is used by pip for example
if [[ -d ~/.local/bin ]]; then
  export PATH=~/.local/bin:$PATH
fi
