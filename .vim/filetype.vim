if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    " SVK commit file
    au! BufNewFile,BufRead svk-commit*.tmp      setf svk

    au! BufNewFile,BufRead mason/*.html         setf mason

    au! BufNewFile,BufRead *.t                  setf perltest
augroup END
