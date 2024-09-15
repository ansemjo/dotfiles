#!/usr/bin/env bash
if iscommand ffmpeg; then

# hide ffmpeg banner by default
# shellcheck disable=SC2262,SC2263
alias ffmpeg="ffmpeg -hide_banner"

iscommand recode || alias recode=ffmpeg-recode

fi
