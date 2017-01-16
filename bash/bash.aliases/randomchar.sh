# output random characters from urandom
randomchar () {
    case $1 in
        ''|*[!0-9]*) AMM=32 ;;
        *) AMM=$1 ;;
    esac
    < /dev/urandom tr -dc "${2:-_A-Z-a-z-0-9}" | head -c${1:-$AMM};echo;
}

# output random hex characters from urandom
randomhex () {
  randomchar "$1" 'A-F0-9';
}
