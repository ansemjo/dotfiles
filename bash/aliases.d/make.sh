#!/usr/bin/env bash
if iscommand make; then

# list possible make targets and somewhat mimic the tab completion in bash
maketargets() { make -p 2>/dev/null | grep -E '^[a-zA-Z0-9_/-]+:[ \t]*' | sed -E 's/^([^ /]+)((\/)[^ ]*)?:.*/\1\3/' | sort -u; }

fi
