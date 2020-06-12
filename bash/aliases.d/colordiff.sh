#!/usr/bin/env bash
# colorful diff if installed
if iscommand colordiff; then
    alias diff='colordiff'
fi
