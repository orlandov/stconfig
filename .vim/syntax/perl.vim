" This file contains Socialtext perl syntax/highlight customizations.

" Avoid infinite loop in this file
if exists("b:st_perl_syntax_init")
    finish
endif
let b:st_perl_syntax_init = 1

" Include system Perl syntax.
runtime! syntax/perl.vim

" Local customizations

" https://www.socialtext.net/dev-guide/index.cgi?CAPSicons
syn keyword stPerlTodo EXTRACT EXTRACT: TODO TODO: REVIEW REVIEW: containedin=perlPod,perlComment
hi def link stPerlTodo perlTodo
syn keyword stSerious XXX XXX: containedin=perlPod,perlComment
hi def link stSerious WarningMsg
syn keyword stDanger FIXME FIXME: containedin=perlPod,perlComment
hi def link stDanger Error

unlet b:st_perl_syntax_init
