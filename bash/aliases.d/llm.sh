#!/usr/bin/env bash

# use github.com/charmbracelet/mods/ to chat with an LLM
if iscommand mods; then

# enter an interactive chat conversation using mods
chat() {
  # pick a model alias from your config
  model=$(yq -r .apis[].models[].aliases[0] ~/.config/mods/mods.yml \
    | grep -i "$*" \
    | gum choose --height 5 --header "Pick model to chat with:" --no-show-help --select-if-one)
  if [[ -z $model ]]; then
    gum format "  :pensive:  cancelled, no model picked." -t emoji
    return 1
  fi
  # first invocation starts a new conversation
  mods --model "$model" --prompt-args || return $?
  # after that enter a loop until user quits, not safe if used concurrently
  while mods --model "$model" --prompt-args --continue-last; do :; done
  return $?;
}

# make mistral easier to use with mods
alias codestral="mods -m codestral"
alias nemo="mods -m mistral-nemo"

fi
