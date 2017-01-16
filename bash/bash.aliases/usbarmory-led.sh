# led control on the usb armory
led ()
{
  if [ $1 ] ; then
    LED="/sys/class/leds/LED/brightness"
    case $1 in
       manual)	modprobe -r ledtrig-heartbeat	;;
       heart)	modprobe ledtrig-heartbeat	;;
       1)	echo 0 > $LED ;;
       on)	echo 0 > $LED ;;
       0)	echo 1 > $LED ;;
       off)	echo 1 > $LED ;;
       *)	echo "use: 0/off or 1/on as argument, when on manual. otherwise use heart or manual to switch the mode"	;;
    esac
  else
    echo "use: 0/off or 1/on as argument"
  fi
}
