set pumheight=15                                                                "Maximum number of entries in autocomplete popup
set completeopt-=preview

augroup vimrc_autocomplete
  autocmd!
  autocmd VimEnter * call s:setup_lsp()
  autocmd FileType javascript,javascriptreact,vim,php,gopls setlocal omnifunc=CustomOmni
augroup END

function! CustomOmni(findstart, base) abort
  if a:findstart == 1
    return -1
  endif
  lua require'complete'.trigger_custom_complete()
  return -2
endfunction

function! s:setup_lsp() abort
  lua require'nvim_lsp'.tsserver.setup{}
  lua require'nvim_lsp'.vimls.setup{}
  lua require'nvim_lsp'.intelephense.setup{}
  lua require'nvim_lsp'.gopls.setup{}
endfunction

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

let s:snippets = {
      \ 'cl': "console.log();\<Left>\<Left>",
      \ 'class': "class {\<CR>}\<C-o>% \<Left>",
      \ }

function s:tab_completion() abort
  let word = matchlist(getline('.')[0:(col('.') - 1)], '\k*$')
  if !empty(word[0]) && has_key(s:snippets, word[0])
    return "\<C-w>".s:snippets[word[0]]
  endif

  if pumvisible()
    return "\<C-n>"
  endif

  if s:check_back_space()
    return "\<TAB>"
  endif

  " Use build in vim completion until issue with neovim is fixed
  " https://github.com/neovim/neovim/issues/12431
  if &filetype ==? 'vim'
    return "\<C-x>\<C-v>"
  endif

  if empty(&omnifunc)
    return "\<C-n>"
  endif

  return "\<C-x>\<C-o>"
endfunction

fun! s:fnameescape(p)
  return escape(fnameescape(a:p), '}')
endf

" Taken from mucomplete
" https://github.com/lifepillar/vim-mucomplete/blob/master/autoload/mucomplete/path.vim#L78
function! CustomPathCompletion() abort
  let l:prefix = matchstr(getline('.'), '\f\%(\f\|\s\)*\%'.col('.').'c')
  while strlen(l:prefix) > 0 " Try to find an existing path (consider paths with spaces, too)
    if l:prefix ==# '~'
      let l:files = glob('~', 0, 1, 1)
      if !empty(l:files)
        call complete(col('.') - 1, map(l:files, '{ "word": v:val, "menu": "[dir]" }'))
        return ''
      endif
      return feedkeys("\<C-g>\<C-g>\<C-n>")
    endif

    let l:files = glob(
          \ (l:prefix !~# '^[/~]'
          \   ? s:fnameescape(expand('%:p:h')) . '/'
          \   : '')
          \ . s:fnameescape(l:prefix) . '*', 0, 1, 1)
    if !empty(l:files)
      call complete(col('.') - len(fnamemodify(l:prefix, ':t')), map(l:files,
            \  '{
            \      "word": fnamemodify(v:val, ":t"),
            \      "menu": (isdirectory(v:val) ? "[dir]" : "[file]"),
            \   }'
            \ ))
      return ''
    endif
    let l:prefix = matchstr(l:prefix, '\%(\s\|=\)\zs.*[/~].*$', 1) " Next potential path
  endwhile
  return feedkeys("\<C-g>\<C-g>\<C-n>")
endfunction

inoremap <silent><expr> <TAB> <sid>tab_completion()

imap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

nmap <leader>ld <cmd>lua vim.lsp.buf.definition()<CR>
nmap <leader>lc <cmd>lua vim.lsp.buf.declaration()<CR>
nmap <leader>lg <cmd>lua vim.lsp.buf.implementation()<CR>
nmap <leader>lu <cmd>lua vim.lsp.buf.references()<CR>
nmap <leader>lr <cmd>lua vim.lsp.buf.rename()<CR>
nmap <leader>lh <cmd>lua vim.lsp.buf.hover()<CR>

set wildoptions=pum
set wildignore=*.o,*.obj,*~                                                     "stuff to ignore when tab completing
set wildignore+=*.git*
set wildignore+=*.meteor*
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*mypy_cache*
set wildignore+=*__pycache__*
set wildignore+=*cache*
set wildignore+=*logs*
set wildignore+=*node_modules*
set wildignore+=**/node_modules/**
set wildignore+=*DS_Store*
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif
