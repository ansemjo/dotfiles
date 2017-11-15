# shorthand to copy directories with rsync, preserving everything
ALIAS='rsync --archive --hard-links --xattrs --acls --executability'
command -v archive >/dev/null && alias rsync-archive="$ALIAS" || alias archive="$ALIAS";
unset ALIAS
