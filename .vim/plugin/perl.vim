set formatoptions-=t

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
        !perl -c -Ilib % && nlwctl -1
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

" Return the module file corresponding to this test file, or the primary test
" corresponding to this module.  Note that this will find Foo.pm from
" Foo-bar.t, but not the other way round.
function! AlternateTestFile(file)
    if (match(a:file, '\.t$') != -1)
        return substitute(substitute(a:file, '^t/', 'lib/', ''), '\(-[^.]\+\)\?\.t$', '.pm', 'm')
    else
        return substitute(substitute(a:file, '^lib/', 't/', ''), '\.pm$', '.t', '')
    endif
endf

