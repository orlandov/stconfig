map ` !G perl -MText::Autoformat -eautoformat<CR>))
map + :e #<CR>

imap  
 
" Fix delete
if &term == "xterm-color"
  set t_kb=
  fixdel
endif

map \] :up<UP><CR>
map \[ :<UP><CR>

map \\\ :noh<CR>:set nopaste<CR>:set nolist<CR>
map \q :q!<CR>
map \p :set paste<CR>
map \v :!vim .vimrc<CR>:so .vimrc<CR>
map \V :!vim ~/.vimrc<CR>:so ~/.vimrc<CR>
map \vf :!vim <cword><CR>:so <cword><CR>

map \# :s/^/# / <CR> :noh <CR>
map \\# :s/^# // <CR> :noh <CR>
map \/ :s,^,// , <CR> :noh <CR>
map \\/ :s,^// ,, <CR> :noh <CR>

" map \1 :up<CR> " ingy doesn't like this (yet)
map \1 :w<CR>
map \2 :up<CR>:!perl -c -Ilib %<CR>
map \3 :up<CR>:call RunLastT()<CR>
map \4 :up<CR>:!prove -ls t<CR>
map \5 :up<CR>:!./%<CR>
map \6 :up<CR>:!make all install<CR>

map \d :.!echo -n 'date:    '; date<CR>
map \h :up<CR>:call TryPerlCompile()<CR>

map \gf :sp <cword><CR>
