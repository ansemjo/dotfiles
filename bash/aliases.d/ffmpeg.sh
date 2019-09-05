# concatenate video files with ffmpeg
# expects absolute filenames on stdin, one per line
if iscommand ffmpeg; then
  ffmpeg-concat() {
    ffmpeg -hide_banner -f concat -safe 0 \
      -i <(while read line; do \
        f=$(readlink -f "$line"); \
        printf "file '%s'\n" "${f/\'/\'}"; \
      done) "$@";
  }
fi
