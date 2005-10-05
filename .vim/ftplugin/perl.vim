" Only run this file once per buffer
if exists("b:did_social_ftplugin")
    finish
endif
let b:did_social_ftplugin = 1

setlocal path+=lib
" XXX - isfname is global, so setting it here sets it everywhere
setlocal isfname+=: iskeyword+=: iskeyword-=-
setlocal keywordprg=perldoc equalprg=st-tidy

" Stolen from vim.org's perl.vim:
setlocal makeprg=perl\ -Ilib\ -wc\ %
" This is cool, but Spiffy doesn't comply:
" setlocal makeprg=perl\ -Wc\ %
setlocal errorformat=%m\ at\ %f\ line\ %l%.%#,
    \%-G%.%#

imap <buffer> <C-x> use Spiffy ':XXX';
" usable as C-/
imap <buffer> <C-_> ->
" make sure you have 'stty -ixon' set before you use this:
imap <buffer> <C-s> $self->

" Vimmersee stuff
map <buffer> \if :!flip-if<cr>
map <buffer> \gs :!grepsubs %<cr>

" Commenting/decommenting:
map <buffer> \# :s/^/#/g<cr>:noh<cr>
map <buffer> \$ :s/^#//g<cr>:noh<cr>

" Run the debugger on the current file (great for .t files)
map <buffer> \pd :up<cr>:!perl -d -Ilib %<cr>

" SocialText - Dangerously (on) and dangerously (not so dangerously),
" test Update (on) and update (off)
map <buffer> \stD :let $NLW_LIVE_DANGEROUSLY=1<cr>
map <buffer> \std :let $NLW_LIVE_DANGEROUSLY=0<cr>
map <buffer> \stU :let $NLW_TEST_UPDATE=1<cr>
map <buffer> \stu :let $NLW_TEST_UPDATE=0<cr>

" quickfix support
map  <buffer> <S-F7>     :wa<CR>:call QuietPerlCompile()<CR>
imap <buffer> <S-F7>     <Esc><S-F7>
map  <buffer> \8         :cnext<CR>
map  <buffer> <S-F8>     :cprev<CR>
imap <buffer> <S-F8>     <Esc><S-F8>
map  <buffer> <M-F8>     :cc<CR>
imap <buffer> <M-F8>     <Esc><M-F8>
