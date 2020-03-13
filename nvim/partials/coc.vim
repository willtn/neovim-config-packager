set pumheight=15                                                                "Maximum number of entries in autocomplete popup

augroup vimrc_autocomplete
  autocmd!
  autocmd VimEnter * call s:setup_lsp()
  autocmd FileType javascript,typescript,javascriptreact,typescriptreact let g:completion_trigger_character = ['.']
  autocmd FileType vim let g:completion_trigger_character = ['.']
  autocmd FileType php let g:completion_trigger_character = ['::', '->', ' ']
augroup END

function! s:setup_lsp() abort
  lua require'nvim_lsp'.tsserver.setup{on_attach=require'completion'.on_attach}
  lua require'nvim_lsp'.vimls.setup{on_attach=require'completion'.on_attach}
  lua require'nvim_lsp'.intelephense.setup{on_attach=require'completion'.on_attach}
endfunction
set completeopt=menuone,noinsert,noselect

let g:completion_enable_snippet = 'UltiSnips'
let g:mucomplete#no_mappings = 1
let g:mucomplete#chains = {
      \ 'default': ['path', 'tags', 'keyn']
      \ }

let g:UltiSnipsExpandTrigger="<c-z>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

imap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<plug>(MUcompleteFwd)"
imap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<plug>(MUcompleteBwd)"

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
