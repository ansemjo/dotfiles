coin() {
  if [[ -n $1 && -n $2 ]]; then
    python -c "import os; print('$1' if int.from_bytes(os.urandom(8), byteorder='big') % 2 else '$2');";
  else
    python -c "import os; print('heads' if int.from_bytes(os.urandom(8), byteorder='big') % 2 else 'tails');";
  fi
}
