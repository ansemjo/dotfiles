# output random characters from urandom
randomchar () {
    case $1 in
        ''|*[!0-9]*) AMM=32 ;;
        *) AMM=$1 ;;
    esac
    < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-$AMM};echo;
}
