# activate a python virtualenv created with:
# $ virtualenv venv/
venv () {
  test -d venv && test -r venv/bin/activate && \
  source venv/bin/activate \
  || { echo "venv/: no virtualenv found" 1>&2; return 1; }
}

