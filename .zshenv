# since .zshenv runs before anything else, we do these here:
[ -e ~/.stconfig-before ] && source ~/.stconfig-before
source ~/.commonrc 
export PROMPT="%{[${COLOR}m%}%m%{[0m%}%# " RPROMPT='%~'
export ZLS_COLORS=$LS_COLORS # comes from ~/.commonrc's dircolors invocation
export HISTSIZE=100000 HISTFILE=~/.zsh_history SAVEHIST=100000
setopt \
    append_history \
    auto_cd \
    auto_list \
    auto_pushd \
    auto_resume \
    cdable_vars \
    NO_clobber \
    complete_in_word \
    correct \
    correct_all \
    equals \
    extended_glob \
    NO_glob_dots \
    hist_ignore_dups \
    NO_hist_ignore_space \
    NO_ignore_eof \
    interactive_comments \
    long_list_jobs \
    mail_warning \
    no_bad_pattern \
    notify \
    print_exit_value \
    pushd_minus \
    pushd_silent \
    pushd_to_home \
    rc_quotes \
