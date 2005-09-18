# since .zshenv runs before anything else, we do these here:
[ -e ~/.stconfig-before ] && source ~/.stconfig-before
source ~/.commonrc 
export PROMPT="%{[${COLOR}m%}%m%{[0m%}%# " RPROMPT='%~'
export ZLS_COLORS=$LS_COLORS # comes from ~/.commonrc's dircolors invocation
export HISTSIZE=100000 HISTFILE=~/.zsh_history SAVEHIST=100000
setopt \
    autocd \
    autolist \
    autopushd \
    autoresume \
    cdablevars \
    correct \
    correctall \
    extendedglob \
    globdots \
    histignoredups \
    longlistjobs \
    mailwarning \
    noclobber \
    noignoreeof \
    notify \
    pushdminus \
    pushdsilent \
    pushdtohome \
    rcquotes \
    appendhistory \
    completeinword \
    equals \
    histignorespace \
    interactivecomments \
    nobadpattern \
    printexitvalue \
