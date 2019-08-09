if iscommand tmux; then

  # attach or create a tmux session
  tm() { session=${1:-tm}; shift 1; tmux at -t "${session}" "$@" || tmux new -s "${session}" "$@"; }

fi
