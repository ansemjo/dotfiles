# pingscan, preferably show all active IPs on local network
pingscan ()
{
if [ $1 ] ; then
 nmap -sn $1 | grep report | sed -e 's/Nmap scan report for //'
else
 echo "please specify a subnet, like so:   pingscan 192.168.0.*"
fi
}
