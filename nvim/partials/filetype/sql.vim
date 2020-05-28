augroup vimrc_sql
  autocmd!
  autocmd FileType sql setlocal equalprg=pg_format
  autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni
  autocmd FileType dbout nnoremap <buffer> <leader>R :call <sid>toggle_view()<CR>
augroup END

function! s:toggle_view() abort
  let content = join(readfile(b:db_input), "\n")
  if content =~? '\\x'
    let content = substitute(content, '\\x', ';', '')
  else
    let content = substitute(content, ';\?$', ' \\x', '')
  endif
  call writefile(split(content, "\n"), b:db_input)
  norm R
endfunction
