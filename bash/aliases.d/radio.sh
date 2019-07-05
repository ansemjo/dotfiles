# play radio livestreams, quietly, show only icy-titles
radio() {
  ch=${1:-info}
  case $ch in
    # Norddeutscher Rundfunk: https://www.ndr.de/radio/index.html
    info)   play="https://www.ndr.de/resources/metadaten/audio_ssl/m3u/ndrinfo_hh.m3u";;
    kultur) play="https://www.ndr.de/resources/metadaten/audio_ssl/m3u/ndrkultur.m3u";;
    # Technobase et. al.: https://www.technobase.fm/
    technobase) play="http://listen.technobase.fm/aac-hd.pls";;
    housetime) play="http://listen.housetime.fm/aac-hd.pls";;
    hardbase) play="http://listen.hardbase.fm/aac-hd.pls";;
    trancetime) play="http://listen.trancetime.fm/aac-hd.pls";;
    coretime) play="http://listen.coretime.fm/aac-hd.pls";;
    # DrumAndBass.fm: http://drumandbass.fm/
    drumandbass) play="http://radio.drumandbass.fm/listen192.m3u";;
    # accept any other argument as stream link
    *) play="$ch";;
  esac
  mpv --no-video --quiet "$play" | sed -n -e '/^Playing/p' -e 's/^ icy-title:/🎶/p'
}

# completion for channels
complete -W "$(command -V radio | sed -n 's/^ \+\([a-z]\+\))$/\1/p')" radio

# alias for ndr streams
alias ndr=radio
complete -W "info kultur" ndr
