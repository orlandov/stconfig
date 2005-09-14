umask 022
# ~/.zshenv takes care of ~/.localrc
source ~/.zaliases
source ~/.zshkeys
stty -ixon
[ -e ~/.afterlocalrc ] && source ~/.afterlocalrc
# ...funny thing is: I split this into files, but it's still just as ugly. =(
