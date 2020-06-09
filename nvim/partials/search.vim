let s:last_search = ''

augroup init_vim_search
  autocmd!
  autocmd FileType qf nnoremap <buffer><Leader>r :call <sid>execute_search()<CR>
  autocmd QuickFixCmdPost [^l]* nested cwindow
  autocmd QuickFixCmdPost l* nested lwindow
augroup END

" Search mappings
nnoremap <expr><Leader>f ":Grep ''\<Left>"
nnoremap <expr><Leader>F ":Grep '".<sid>escape(expand('<cword>'))."' "
vnoremap <Leader>F :<C-u>call <sid>get_visual_search_cmd()<CR>

command! -nargs=+ -complete=file -bar Grep cgetexpr Grep(<q-args>)

function! Grep(arg)
  let grepprg = &grepprg
  if a:arg ==? "''"
    echom 'Empty search.'
    return []
  endif

  if a:arg =~? "^'"
    let grepprg .= ' --fixed-strings'
  endif

  let cmd = join([grepprg, a:arg])
  let s:last_search = a:arg
  let results = system(cmd)
  if empty(results)
    echom 'No results for search -> '.a:arg
  endif
  if !empty(v:shell_error) && !empty(results)
    echom 'Search error (status: '.v:shell_error.'): '.string(results)
  endif

  return results
endfunction

function s:execute_search() abort
  if !empty(s:last_search)
    cgetexpr Grep(s:last_search)
  endif
endfunction

function s:get_visual_search_cmd() abort
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][:col2 - (&selection ==? 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return feedkeys(":Grep '".s:escape(join(lines, "\n"))."' ")
endfunction

function! s:escape(val)
  return escape(a:val, '#')
endfunction

