if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    " SVK commit file
    au! BufNewFile,BufRead svk-commit*.tmp      setf svk
augroup END
