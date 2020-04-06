set pumheight=15                                                                "Maximum number of entries in autocomplete popup

augroup vimrc_autocomplete
  autocmd!
  autocmd VimEnter * call s:setup_lsp()
  autocmd FileType javascript,typescript,javascriptreact,typescriptreact let g:completion_trigger_character = ['.']
  autocmd FileType vim let g:completion_trigger_character = ['.']
  autocmd FileType php let g:completion_trigger_character = ['::', '->', ' ']
  autocmd BufEnter * lua require'completion'.on_attach()
augroup END

function! s:setup_lsp() abort
  lua require'nvim_lsp'.tsserver.setup{on_attach=require'completion'.on_attach}
  lua require'nvim_lsp'.vimls.setup{on_attach=require'completion'.on_attach}
  lua require'nvim_lsp'.intelephense.setup{on_attach=require'completion'.on_attach}
  lua require'nvim_lsp'.gopls.setup{on_attach=require'completion'.on_attach}
endfunction
set completeopt=menuone,noinsert,noselect

let g:completion_enable_snippet = 'UltiSnips'
let g:completion_confirm_key_rhs = "\<Plug>delimitMateCR"
let g:completion_auto_change_source = 1
let g:completion_chain_complete_list = [
    \{'complete_items': ['lsp', 'snippet']},
    \{'mode': 'tags'},
    \{'mode': 'file'},
    \{'mode': '<c-p>'},
    \{'mode': '<c-n>'},
\]

let g:UltiSnipsExpandTrigger="<c-z>"
let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsJumpBackwardTrigger="<c-p>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ completion#trigger_completion()
  \
imap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

imap <c-j> <cmd>lua require'source'.prevCompletion()<CR>
imap <c-k> <cmd>lua require'source'.nextCompletion()<CR>

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
