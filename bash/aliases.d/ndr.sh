# play ndr livestreams, quietly, show only icy-titles
# https://www.ndr.de/radio/index.html
ndr() {
  ch=${1:-info}
  case $ch in
    info)   m3u="https://www.ndr.de/resources/metadaten/audio_ssl/m3u/ndrinfo_hh.m3u";;
    kultur) m3u="https://www.ndr.de/resources/metadaten/audio_ssl/m3u/ndrkultur.m3u";;
    *) echo "unknown channel! (info, kultur)"; return 1;;
  esac
  mpv --no-video --quiet "$m3u" | sed -n -e '/^Playing/p' -e 's/^ icy-title:/🎶/p'
}

# completion for channels
complete -W "info kultur" ndr
