if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    au! BufNewFile,BufRead svk-commit*.tmp      setf svk

    au! BufNewFile,BufRead mason/*.html         setf mason
    au BufRead,BufNewFile *.mas set ft=mason

    au! BufNewFile,BufRead *.t                  setf perltest
    au! BufNewFile,BufRead *.hwd                setf hwd
    au! BufNewFile,BufRead *.wiki               setf wiki

    au! BufNewFile,BufRead *.html
        \ if ( getline(1) . getline(2) . getline(3) =~ '\[%' ) |
        \   setf tt2html |
        \ else |
        \   setf html |
        \ endif
    au BufNewFile,BufRead *.tt2
        \ if ( getline(1) . getline(2) . getline(3) =~ '<\chtml'
        \           && getline(1) . getline(2) . getline(3) !~ '<[%?]' )
        \   || getline(1) =~ '<!DOCTYPE HTML' |
        \   setf tt2html |
        \ else |
        \   setf tt2 |
        \ endif
    "TT2 and HTML"
    :let b:tt2_syn_tags = '\[% %] <!-- -->'

    " Git, taken from vim 7.2's filetype.vim
    autocmd BufNewFile,BufRead *.git/COMMIT_EDITMSG    setf gitcommit 
    autocmd BufNewFile,BufRead *.git/config,.gitconfig setf gitconfig 
    autocmd BufNewFile,BufRead git-rebase-todo         setf gitrebase 
    autocmd BufNewFile,BufRead .msg.[0-9]* 
          \ if getline(1) =~ '^From.*# This line is ignored.$' | 
          \   setf gitsendemail | 
          \ endif 
    autocmd BufNewFile,BufRead *.git/** 
          \ if getline(1) =~ '^\x\{40\}\>\|^ref: ' | 
          \   setf git | 
          \ endif

    au BufNewFile,BufRead *.mxml set filetype=mxml
    au BufNewFile,BufRead *.as set filetype=actionscript
augroup END

