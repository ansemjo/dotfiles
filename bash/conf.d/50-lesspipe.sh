#!/usr/bin/env bash

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && export LESSOPEN="|lesspipe %s"
