# since .zshenv runs before anything else, we do these here:
[ -e ~/.stconfig-before ] && source ~/.stconfig-before
source ~/.commonrc 
export ZLS_COLORS=$LS_COLORS # comes from ~/.commonrc's dircolors invocation
export HISTSIZE=100000 HISTFILE=~/.zsh_history SAVEHIST=100000
export HISTFILE=~/.zsh_history
export SAVEHIST=1000
export HISTSIZE=1000
setopt \
    promptsubst \
    nopromptcr \
    bash_auto_list \
    no_auto_menu \
    no_always_last_prompt \
    hist_ignore_dups \
    hist_ignore_space \
    extended_history \
    append_history \
    auto_cd \
    auto_list \
    NO_auto_pushd \
    auto_resume \
    NO_cdable_vars \
    NO_clobber \
    complete_in_word \
    correct \
    correct_all \
    equals \
    extended_glob \
    extended_history \
    NO_glob_dots \
    NO_hist_ignore_space \
    NO_ignore_eof \
    interactive_comments \
    list_types \
    long_list_jobs \
    mail_warning \
    no_bad_pattern \
    notify \
    numeric_glob_sort \
    print_exit_value \
    pushd_minus \
    pushd_silent \
    pushd_to_home \
    rc_quotes \

