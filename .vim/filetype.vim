if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    au! BufNewFile,BufRead svk-commit*.tmp      setf svk

    au! BufNewFile,BufRead mason/*.html         setf mason
    au BufRead,BufNewFile *.mas set ft=mason

    au! BufNewFile,BufRead *.t                  setf perltest
augroup END
