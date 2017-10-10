# weather forecast, allow insecure (their ssl cert is selfsigned and it's better than nothing)
weather() { curl --insecure "https://wttr.in/${1}"; }
