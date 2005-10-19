imap <buffer> <C-x> var a=[],str='';for(p in )a.push(p);a.sort();alert(a);<esc>4F)i

" 'Alert Here'
map <buffer> \ah :exec 'normal Oalert(' . line('.') . ');'<cr>
