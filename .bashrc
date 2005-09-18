# This is crufty.  As soon as everyone using bash has moved their personal
# stuff to ~/stconfig-{before,after}, we can slurp ~/.bashrc_st into this file
source ~/.bashrc_st
[ -e ~/.stconfig-after ] && source ~/.stconfig-after
