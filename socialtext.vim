" Find where the plugins are stored by looking relative to this file.
let s:ST_CONFIG_DIR = fnamemodify(resolve(expand("<sfile>")),":~:.:h")
let s:ST_PLUGIN_DIR = s:ST_CONFIG_DIR . "/.vim/plugin/"

exe 'source ' . s:ST_CONFIG_DIR . '/.vimrc'

function s:LoadSTPlugin(name)
    exe 'source ' . s:ST_PLUGIN_DIR . a:name
endfunction

" If you add a plugin, please add it here.
" If you know how to make this into a loop over 'ls .vim/plugin', fix it.
call s:LoadSTPlugin("basics.vim")
call s:LoadSTPlugin("diff.vim")
call s:LoadSTPlugin("functionkeys.vim")
call s:LoadSTPlugin("keymaps.vim")
call s:LoadSTPlugin("perl.vim")
call s:LoadSTPlugin("quicklang.vim")
call s:LoadSTPlugin("svn.vim")
