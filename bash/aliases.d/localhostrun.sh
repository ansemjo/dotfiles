# use localhost.run to expose a local port on the internet
localhostrun() {
  PORT=${1:?localhost port required}
  ssh -o ControlPath=none -R "80:localhost:$PORT" ssh.localhost.run
}

iscommand expose || alias expose=localhostrun
