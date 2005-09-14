" These should be vim defaults, I think:
au BufRead,BufNewFile *.t set ft=perl
au BufRead,BufNewFile *.mas set ft=mason

set path+=lib
set isfname+=: iskeyword+=: iskeyword-=-
setlocal keywordprg=perldoc equalprg=st-tidy

" Stolen from vim.org's perl.vim:
setlocal makeprg=perl\ -wc\ %
" This is cool, but Spiffy doesn't comply:
" setlocal makeprg=perl\ -Wc\ %
setlocal errorformat=%m\ at\ %f\ line\ %l%.%#,
    \%-G%.%#

imap <C-x> use Spiffy ':XXX';
" usable as C-/
imap <C-_> ->
" make sure you have 'stty -ixon' set before you use this:
imap <C-s> $self->

" Run the debugger on the current file (great for .t files)
map \pd :up<cr>:!perl -d -Ilib %<cr>

" Vimmersee stuff
map \if :!flip-if<cr>
map \gs :!grepsubs %<cr>

" Commenting/decommenting:
map \# :s/^/#/g<cr>:noh<cr>
map \$ :s/^#//g<cr>:noh<cr>

function! RunLastT()
    if (expand('%:e') == 't')
        let $lasttfile = expand('%')
    endif
    if (!strlen($lasttfile))
       execute '!./' . expand('%')
    else
        !prove -lv $lasttfile
    endif
endf

function! TryPerlCompile()
    let ext = expand('%:e')
    if (ext == 'pm' || ext == 'pl' || ext == 't' || ext == '')
        !perl -c -Ilib % && nlwctl
    endif
endf
