syntax on

set incsearch ignorecase smartcase history=9999 ruler laststatus=2 backspace=2
set autoindent expandtab tabstop=4 shiftwidth=4 softtabstop=4 textwidth=78
set autoread autowrite nobackup exrc ttyfast viminfo='20,\"500
set backspace=indent,eol,start hlsearch notimeout clipboard=
set suffixes=.bak,~,.o,.h,.info,.swp,.obj,.class wildmode=list:longest,full
set background=dark visualbell
set encoding=utf-8 termencoding=utf-8

au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
