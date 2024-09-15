#!/usr/bin/env bash

# use github.com/charmbracelet/mods/ to chat with an LLM
if iscommand mods; then

# make mistral easier to use with mods
alias codestral="mods -m codestral"
alias nemo="mods -m mistral-nemo"

fi
