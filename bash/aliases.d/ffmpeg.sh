# concatenate video files with ffmpeg
# expects absolute filenames on stdin, one per line
if iscommand ffmpeg; then
ffmpeg-concat() {
  ffmpeg -f concat -safe 0 -i <(sed "s/^/file '/; s/$/'/") -c copy "$@";
}
fi
