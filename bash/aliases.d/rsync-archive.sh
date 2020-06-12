#!/usr/bin/env bash
# shorthand to copy directories with rsync, preserving everything
alias rsync-archive='rsync --archive --hard-links --xattrs --acls --executability'
if ! iscommand archive; then
  alias archive='rsync-archive'
fi
