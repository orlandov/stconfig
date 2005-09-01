" Ingy's vim configuration file
set incsearch		" do incremental searching
set history=9999
set nolist
imap  
set encoding=utf8
set termencoding=utf8

" Fix delete
if &term == "xterm-color"
  set t_kb=
  fixdel
endif

" Non-laptop equivalents
map <F1> \1
map <F2> \2
map <F3> \3
map <F4> \4
map <F5> \5
map <F6> \6
map <F7> \7
map <F8> \8
map <F9> \9
map <F10> \0
map <F11> \H
map <F12> \h
map \] :w<UP><CR>
map \[ :<UP><CR>

" Default shortcuts
map O5P :w! <CR> :!p4 edit % <CR>   " <CTL><F1>
map \1 :w! <CR>
map \2 :w! <CR> :!perl -Ilib -c % <CR>
map \3 :w! <CR> :call LastT()<CR>
map \4 :w! <CR> :!make test <CR>
map \5 :w! <CR> :!sudo make install <CR>
map <F8> :!grep -nIr --exclude=blib --exclude=.svn <cword> .
map <F8><F8> :!grep -nIr --exclude="*/.svn/*" <cword> lib<CR>

map +  :e # <CR>
map \x :x!
map \q :q!<CR>
map \H :up<cr>:!arestart<cr>
map \h :call Hup()<cr>
map \= :source ~/.vimrc<CR>
map \+ :w<CR> :!scp % ttul.org:<CR>
map \\ :nohlsearch<CR>:set nolist<cr>:set nopaste<CR>
map \p :set paste<CR>0i
map \D :up<cr>:!perl -d -Ilib %<cr>
map \l :set list!<CR>
map \w :set wrap!<CR>
map \v :!vim .vimrc<CR> :source .vimrc <CR>
map \V :!vim ~/.vimrc<CR> :source ~/.vimrc <CR>
map \` :!cat .vimrc \| grep -v ^\" <CR>
map \# :s/^/# /g <CR> :noh <CR>
map \$ :s/^# //g <CR> :noh <CR>
map ` !G perl -MText::Autoformat -eautoformat<CR>))
map \if !flip-if<CR>
map \pd :up<cr>:!perl -d -Ilib %<cr>
map \sd :!svndiff %<cr>
map \sD :!svndiff<cr>
map \sc :!svn ci %<cr>
map \sC :!svn ci<cr>
map \sb :!svn blame % \| vim-pager<cr>
map \sl :!svn log % \| vim-pager<cr>
map \sREVERT :!svn revert %<cr>
map \scREVERT :!svn revert <cword><cr>

" map  :q! <CR>

au BufNewFile,BufRead *.t set ft=perl
autocmd FileType perl set iskeyword=48-57,_,A-Z,a-z

function! LastT()
    up
    if (expand('%:e') == 't')
        let $lasttfile = expand('%')
    endif
    if (!strlen($lasttfile))
        execute '!perl -Ilib' expand('%')
    else
        execute '!perl -Ilib' $lasttfile
    endif
endfunction

function! Hup()
    up
    let ext = expand('%:e')
    if (ext == 'pm' || ext == 'pl' || ext == 't' || ext == '')
        !perl -c -Ilib % && ahup
    else
        !ahup
    endif
endfunction
 
set background=dark
set exrc
set autowrite
set vb      " use a visual flash instead of beeping
set ru      " display column, line info

set expandtab
set autoindent
set shiftwidth=4
set tabstop=8
set softtabstop=4

set tw=78
if has("syntax")
  if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
  endif
endif
if has("mouse")
  set mouse=nvi	" use mouse support in xterm
endif
set ignorecase          " ignore case in search patterns ...
set smartcase           " ... unless pattern contains uppercase

" if has("folding")
"   set foldmethod=syntax
"   let perl_fold=1
" endif

set backspace=indent,eol,start

if has("autocmd")
  filetype plugin indent on

"  au FileType text setlocal textwidth=78
"  au FileType python setlocal foldmethod=indent
  au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

" This makes editing mail in Mutt oh-so-much more pleasant
  au FileType mail map to gg/^ToA
  au FileType mail map cc gg/^CcA
  au FileType mail map su gg/^SubjectA
  au FileType mail map bo gg}o

endif

" alt+.
imap ® ->
" alt+s
imap ó $self->

imap <f1> <esc><f1>
imap <f2> <esc><f2>
imap <f3> <esc><f3>
imap <f4> <esc><f4>
imap <f5> <esc><f5>
imap <f6> <esc><f6>
imap <f7> <esc><f7>
imap <f8> <esc><f8>
imap <f9> <esc><f9>
imap <f10> <esc><f10>
imap <f11> <esc><f11>
imap <f12> <esc><f12>
