set pumheight=15                                                                "Maximum number of entries in autocomplete popup
set completeopt-=preview

let s:complete_finished = v:false
augroup vimrc_autocomplete
  autocmd!
  autocmd VimEnter * call s:setup_lsp()
  autocmd FileType javascript,javascriptreact,vim,php,gopls setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd CompleteDone * let s:complete_finished = v:true
augroup END

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

  let s:complete_finished = v:false
  call timer_start(10, function('s:verify_completion'), { 'repeat': -1 })
  return "\<C-x>\<C-o>"
endfunction

function! s:verify_completion(timer) abort
  if s:complete_finished
    call timer_stop(a:timer)
    if !pumvisible()
      call feedkeys("\<C-e>\<C-n>")
    endif
  endif
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
