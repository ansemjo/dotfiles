# pipe files with tar via ssh
tarpipe() {
mode="$1"; shift
pipe="/tmp/.tarpipe"
usage="Usage:
 tarpipe receive[r] \$host     #note: reveiveR loops
 tarpipe fetch \$host \$files  #note: uses sudo!
 tarpipe send \$files"

case "$mode" in
    receive|receiver )
        test -n "$1" && host="$1" && shift || { echo "$usage"; return 1; }
        test "$mode" = "receiver" && echo "RECEIVER .. (loop, CTRL-C to exit ..)" || echo "RECEIVE"
        while true; do
            ssh $host "test -e $pipe && rm -f $pipe; mkfifo $pipe; cat $pipe; rm $pipe" 2>/dev/null |\
              tar xvkf - --xform s:^.*/::
            test "$mode" = "receiver" || break
        done ;;

    send )
        test -n "$1" || { echo "$usage"; return 1; }
        echo "SENDER ..."
        while test ! -e $pipe; do echo "no receiver present ... waiting ..."; sleep 5; done
        tar cv --xform s:^.*/:: -f $pipe $@;;

    fetch )
        test -n "$1" && host="$1" && shift || { echo "$usage"; return 1; }
        test -n "$1" || { echo "$usage"; exit 1; }
        echo "FETCHING ..."
        (ssh $host "test -e $pipe && rm -f $pipe; mkfifo $pipe; cat $pipe; rm $pipe" 2>/dev/null |\
          tar xkf - )&
        ssh -t $host "sudo tar cv --xform s:^.*/:: -f $pipe $*" ;;

    * )
        echo "$usage"; return 1;;
esac
}
