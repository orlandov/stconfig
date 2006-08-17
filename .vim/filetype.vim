if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    au! BufNewFile,BufRead svk-commit*.tmp      setf svk

    au! BufNewFile,BufRead mason/*.html         setf mason
    au BufRead,BufNewFile *.mas set ft=mason

    au! BufNewFile,BufRead *.t                  setf perltest
    au! BufNewFile,BufRead *.hwd                setf hwd

    au! BufNewFile,BufRead *.html
        \ if ( getline(1) . getline(2) . getline(3) =~ '\[%' ) |
        \   setf tt2html |
        \ else |
        \   setf html |
        \ endif
augroup END
