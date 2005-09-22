" vim:ft=vim
" If you call this, it works even if path is a symlink to a working copy.
function ResolvedShellCmd(cmd, path)
    exe '! ' . a:cmd . ' ' . resolve(expand(a:path))
endfunction

" Try 'export SVN_COMMAND=svk'.
function SvnCmd(cmd, path)
    if $SVN_COMMAND == ''
        let s:SVN_COMMAND = 'svn'
    else
        let s:SVN_COMMAND = $SVN_COMMAND
    endif
    call ResolvedShellCmd(s:SVN_COMMAND . ' ' . a:cmd, a:path)
endfunction

map \sD :!svndiff<cr>

map \sd :call ResolvedShellCmd('svndiff', '%')<cr>
map \sld :call ResolvedShellCmd('svnlastdiff', '%')<cr>
map \sb :call ResolvedShellCmd('svnblame ', '%')<cr>
map \sl :call ResolvedShellCmd('svnlog ', '%')<cr>
map \sci :call SvnCmd('ci ', '%')<cr>
map \sREVERT :call SvnCmd('revert', '%')<cr>:e<cr>

map \sfd :call SvnCmd('diff', '<cword>')<cr>
map \sfld :call ResolvedShellCmd('svnlastdiff', '<cword>')<cr>
map \sfb :call ResolvedShellCmd('svnblame', '<cword>')<cr>
map \sfl :call ResolvedShellCmd('svnlog', '<cword>')<cr>
map \sfci :call SvnCmd('ci', '<cword>')<cr>
map \sfREVERT :call SvnCmd('revert', '<cword>')<cr>
