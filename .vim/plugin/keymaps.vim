map ` !G perl -MText::Autoformat -eautoformat<CR>))
map + :e #<cr>

imap  
 
" Fix delete
if &term == "xterm-color"
  set t_kb=
  fixdel
endif

map \] :up<UP><CR>
map \[ :<UP><CR>

map \\ :noh<cr>:set nopaste<cr>:set nolist<cr>
map \p :set paste<cr>
map \v :!vim .vimrc<cr>:so .vimrc<cr>
map \V :!vim ~/.vimrc<cr>:so ~/.vimrc<cr>
map \vf :!vim <cword><cr>:so <cword><cr>

map \# :s/^/# /g <CR> :noh <CR>
map \\# :s/^# //g <CR> :noh <CR>
map \/ :s/^/\/ /g <CR> :noh <CR>
map \\/ :s/^\/ //g <CR> :noh <CR>

map \1 :w!<cr>
map \2 :up<cr>:!perl -c -Ilib %<cr>
map \3 :up<cr>:call RunLastT()<cr>
map \4 :up<cr>:!make test<cr>
map \5 :up<cr>:!./%<cr>
map \6 :up<cr>:!make all install<cr>

map \d :.!echo -n 'date:    '; date<cr>
map \h :up<cr>:call TryPerlCompile()<cr>

map \gf :sp <cword><cr>
