#dirsize - finds directory sizes and lists them for the current directory
dirsize ()
{
 du -shx * .[a-zA-Z0-9_]* 2> /dev/null | \
 egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
 egrep '^ *[0-9.]*M' /tmp/list
 egrep '^ *[0-9.]*G' /tmp/list
 rm -rf /tmp/list
}
