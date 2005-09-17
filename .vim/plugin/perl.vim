" These should be vim defaults, I think:
au BufRead,BufNewFile *.t set ft=perl
au BufRead,BufNewFile *.mas set ft=mason

function! RunLastT()
    if (expand('%:e') == 't')
        let $lasttfile = expand('%')
    endif
    if (!strlen($lasttfile))
       execute '!./' . expand('%')
    else
        !prove -lv $lasttfile
    endif
endf

function! TryPerlCompile()
    let s:ext = expand('%:e')
    if (s:ext == 'pm' || s:ext == 'pl' || s:ext == 't' || s:ext == '')
        !perl -c -Ilib % && nlwctl
    endif
endf

function! QuietPerlCompile()
    let s:old_sp = &sp
    set sp=>&
    silent make
    let &sp = s:old_sp

    cwin
    if (! v:shell_error)
        echo 'syntax ok'
    endif
endf
