export LANG="C"
TZ='America/Los_Angeles'; export TZ
# This is crufty.  As soon as everyone using bash has moved their personal
# stuff to ~/stconfig-{before,after}, we can slurp ~/.bashrc_st into this file
[ -r ~/.bashrc_st ] && source ~/.bashrc_st
[ -r ~/.stconfig-after ] && source ~/.stconfig-after
