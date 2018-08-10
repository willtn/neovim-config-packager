" ================ Plugins ==================== {{{
if exists('*minpac#init')
  call minpac#init()
  " Manually loaded plugins
  call minpac#add('k-takata/minpac', {'type': 'opt'})
  " Auto loaded plugins
  call minpac#add('morhetz/gruvbox')
  call minpac#add('justinmk/vim-dirvish')
  call minpac#add('sheerun/vim-polyglot')
  call minpac#add('junegunn/fzf', { 'do': '!./install --all && ln -s $(pwd) ~/.fzf'})
  call minpac#add('junegunn/fzf.vim')
endif

command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update() | call minpac#status()
command! PackClean packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()

"}}}
" ================ General Config ==================== {{{

let g:loaded_netrwPlugin = 1                                                    "Do not load netrw so Dirvish can be autoloaded

let g:mapleader = ','                                                           "Change leader to a comma

let g:gruvbox_italic = 1                                                        "Enable italics in Gruvbox colorscheme
let g:gruvbox_invert_selection = 0                                              "Do not invert selection in Gruvbox colorscheme
let g:gruvbox_sign_column = 'bg0'                                               "Use default bg color in sign column

set termguicolors
set title                                                                       "change the terminal's title
set number                                                                      "Line numbers are good
set relativenumber                                                              "Show numbers relative to current line
set history=500                                                                 "Store lots of :cmdline history
set showcmd                                                                     "Show incomplete cmds down the bottom
set noshowmode                                                                  "Hide showmode because of the powerline plugin
set gdefault                                                                    "Set global flag for search and replace
set guicursor=a:blinkon500-blinkwait500-blinkoff500                             "Set cursor blinking rate
set cursorline                                                                  "Highlight current line
set smartcase                                                                   "Smart case search if there is uppercase
set ignorecase                                                                  "case insensitive search
set mouse=a                                                                     "Enable mouse usage
set showmatch                                                                   "Highlight matching bracket
set nostartofline                                                               "Jump to first non-blank character
set ttimeoutlen=0                                                               "Reduce Command timeout for faster escape and O
set fileencoding=utf-8                                                          "Set utf-8 encoding on write
set wrap                                                                        "Enable word wrap
set linebreak                                                                   "Wrap lines at convenient points
set listchars=tab:\ \ ,trail:·                                                  "Set trails for tabs and spaces
set list                                                                        "Enable listchars
set lazyredraw                                                                  "Do not redraw on registers and macros
set background=dark                                                             "Set background to dark
set hidden                                                                      "Hide buffers in background
set conceallevel=2 concealcursor=i                                              "neosnippets conceal marker
set splitright                                                                  "Set up new vertical splits positions
set splitbelow                                                                  "Set up new horizontal splits positions
set path+=**                                                                    "Allow recursive search
set inccommand=nosplit                                                          "Show substitute changes immidiately in separate split
set fillchars+=vert:\│                                                          "Make vertical split separator full line
set pumheight=15                                                                "Maximum number of entries in autocomplete popup
set exrc                                                                        "Allow using local vimrc
set secure                                                                      "Forbid autocmd in local vimrc
set grepprg=rg\ --vimgrep                                                       "Use ripgrep for grepping
set tagcase=smart                                                               "Use smarcase for tags
set updatetime=500                                                              "Cursor hold timeout
set synmaxcol=300                                                               "Use syntax highlighting only for 300 columns
set shortmess+=c
set completeopt=menuone,longest

syntax on
silent! colorscheme gruvbox
hi! link jsFuncCall GruvboxBlue
" Remove highlighting of Operator because it is reversed with cursorline enabled
hi! Operator guifg=NONE guibg=NONE

" }}}
" ================ Turn Off Swap Files ============== {{{

set noswapfile
set nobackup
set nowritebackup

" }}}
" ================ Persistent Undo ================== {{{

" Keep undo history across sessions, by storing in file.
silent !mkdir ~/.config/nvim/backups > /dev/null 2>&1
set undodir=~/.config/nvim/backups
set undofile

" }}}
" ================ Indentation ====================== {{{

set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
set breakindent
set smartindent
set nofoldenable
set colorcolumn=80
set foldmethod=syntax

" }}}
" ================ Auto commands ====================== {{{

augroup vimrc
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow                                       "Open quickfix window after grepping
  autocmd BufWritePre * call StripTrailingWhitespaces()                       "Auto-remove trailing spaces
  autocmd InsertEnter * set nocul                                             "Remove cursorline highlight
  autocmd InsertLeave * set cul                                               "Add cursorline highlight in normal mode
  autocmd FocusGained,BufEnter * checktime                                    "Refresh file when vim gets focus
  autocmd FileType dirvish call DirvishMappings()
  autocmd BufWritePre,FileWritePre * call mkdir(expand('<afile>:p:h'), 'p')
  autocmd BufEnter,BufWritePost,TextChanged,TextChangedI * call HighlightModified()
  autocmd BufWritePost * silent exe '!rg --files | ctags -R --links=no -L -'
augroup END

augroup php
  autocmd!
  autocmd FileType php setlocal shiftwidth=4 softtabstop=4 tabstop=4
augroup END

augroup javascript
  autocmd!
  autocmd FileType javascript setlocal makeprg=./node_modules/.bin/eslint\ --format\ compact\ %
  autocmd FileType javascript set errorformat+=%f:\ line\ %l\\,\ col\ %c\\,\ %trror\ -\ %m
  autocmd Filetype javascript set errorformat+=%f:\ line\ %l\\,\ col\ %c\\,\ %tarning\ -\ %m
  autocmd Filetype javascript inoremap <buffer>cl<CR> console.log()<Left>
augroup END

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu | set nornu | endif
augroup END

" }}}
" ================ Completion ======================= {{{

set wildmode=list:full
set wildignore=*.o,*.obj,*~                                                     "stuff to ignore when tab completing
set wildignore+=*.git*
set wildignore+=*.meteor*
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*cache*
set wildignore+=*logs*
set wildignore+=*node_modules/**
set wildignore+=*DS_Store*
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

" }}}
" ================ Scrolling ======================== {{{

set scrolloff=8                                                                 "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=5

" }}}
" ================ Statusline ======================== {{{

set statusline=%1*\ %{StatuslineMode()}                                         "Mode
set statusline+=\ %*%2*%{StatuslineFn('GitStatusline')}%*                       "Git branch and status
set statusline+=\ %f                                                            "File path
set statusline+=\ %m                                                            "Modified indicator
set statusline+=\ %w                                                            "Preview indicator
set statusline+=\ %r                                                            "Read only indicator
set statusline+=\ %q                                                            "Quickfix list indicator
set statusline+=\ %=                                                            "Start right side layout
set statusline+=\ %{StatuslineFn('anzu#search_status')}                         "Search status
set statusline+=\ %2*\ %{&ft}                                                   "Filetype
set statusline+=\ \│\ %p%%                                                      "Percentage
set statusline+=\ \│\ %c                                                        "Column number
set statusline+=\ \│\ %l/%L\                                                    "Current line number/Total line numbers

hi User1 guifg=#504945 gui=bold
hi User2 guibg=#665c54 guifg=#ebdbb2

function! StatuslineFn(name) abort
  try
    return call(a:name, [])
  catch
    return ''
  endtry
endfunction

function! GitStatusline() abort
  let l:branch = system('git rev-parse --abbrev-ref HEAD 2>/dev/null')
  if empty(l:branch)
    return ''
  endif
  return ' '.l:branch[:-2].' '
endfunction

function! HighlightModified() abort
  let l:is_modified = getwinvar(winnr(), '&mod') && getbufvar(bufnr(''), '&mod')

  if empty(l:is_modified)
    hi StatusLine guifg=#ebdbb2 guibg=#504945 gui=NONE
    return ''
  endif

  hi StatusLine guifg=#ebdbb2 guibg=#fb4934 gui=NONE
  return ''
endfunction

function! StatuslineMode() abort
  let l:mode = mode()
  call ModeHighlight(l:mode)
  let l:modeMap = {
  \ 'n'  : 'NORMAL',
  \ 'i'  : 'INSERT',
  \ 'R'  : 'REPLACE',
  \ 'v'  : 'VISUAL',
  \ 'V'  : 'V-LINE',
  \ 'c'  : 'COMMAND',
  \ '' : 'V-BLOCK',
  \ 's'  : 'SELECT',
  \ 'S'  : 'S-LINE',
  \ '' : 'S-BLOCK',
  \ 't'  : 'TERMINAL',
  \ }

  return get(l:modeMap, l:mode, 'UNKNOWN')
endfunction

function! ModeHighlight(mode) abort
  if a:mode ==? 'i'
    hi User1 guibg=#83a598
  elseif a:mode =~? '\(v\|V\|\)'
    hi User1 guibg=#fe8019
  elseif a:mode ==? 'R'
    hi User1 guibg=#8ec07c
  else
    hi User1 guibg=#928374
  endif
endfunction

"}}}
" ================ Abbreviations ==================== {{{

cnoreabbrev Wq wq
cnoreabbrev WQ wq
cnoreabbrev Wqa wqa
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qa qa
cnoreabbrev Bd bd
cnoreabbrev wrap set wrap
cnoreabbrev nowrap set nowrap
cnoreabbrev E e

" }}}
" ================ Functions ======================== {{{

function! StripTrailingWhitespaces()
  if &modifiable
    let l:l = line('.')
    let l:c = col('.')
    call execute('%s/\s\+$//e')
    call histdel('/', -1)
    call cursor(l:l, l:c)
  endif
endfunction

function! CommentLine(line_number) abort
  let l:comment_string = getbufvar(bufnr(''), '&commentstring')
  let l:markers = map(split(l:comment_string, '%s'), {-> escape(v:val, '*')})
  let l:line = getline(a:line_number)
  if l:line =~? '^'.l:markers[0]
    if len(l:markers) ==? 1
      return setline(a:line_number, substitute(l:line, '^\('.l:markers[0].'\)\(.*\)', '\2', 'g'))
    endif
      return setline(a:line_number, substitute(l:line, '^\('.l:markers[0].'\)\(.*\)\('.l:markers[1].'\)', '\2', 'g'))
  endif

  return setline(a:line_number, printf(l:comment_string, l:line))
endfunction


function! Comment(...) abort
  let l:is_visual = a:0 > 0

  if !l:is_visual
    return CommentLine(line('.'))
  endif

  let [l:line_start, l:column_start] = getpos("'<")[1:2]
  let [l:line_end, l:column_end] = getpos("'>")[1:2]
  let l:lines = getline(l:line_start, l:line_end)

  if len(l:lines) ==? 0
    return 0
  endif

  let l:index = 0
  for l:line in l:lines
    call CommentLine(l:line_start + l:index)
    let l:index += 1
  endfor
endfunction

function! Search(...)
  let l:default = a:0 > 0 ? expand('<cword>') : ''
  let l:term = input('Search for: ', l:default)
  if l:term !=? ''
    let l:path = input('Path: ', '', 'file')
    execute 'grep "'.l:term.'" '.l:path
  endif
endfunction

function! CloseBuffer(...) abort
  if &buftype !=? ''
    return execute('q!')
  endif
  let l:windowCount = winnr('$')
  let l:totalBuffers = len(getbufinfo({ 'buflisted': 1 }))
  let l:noSplits = l:windowCount ==? 1
  let l:bang = a:0 > 0 ? '!' : ''
  if l:totalBuffers > 1 && l:noSplits
    let l:command = 'bp'
    if buflisted(bufnr('#'))
      let l:command .= '|bd'.l:bang.'#'
    endif
    return execute(l:command)
  endif
  return execute('q'.l:bang)
endfunction

function! DirvishMappings() abort
  nnoremap <silent><buffer> o :call dirvish#open('edit', 0)<CR>
  nnoremap <silent><buffer> s :call dirvish#open('vsplit', 1)<CR>
  xnoremap <silent><buffer> o :call dirvish#open('edit', 0)<CR>
  nmap <silent><buffer> u <Plug>(dirvish_up)
  nmap <silent><buffer><Leader>n <Plug>(dirvish_quit)
  silent! unmap <buffer> <C-p>
  nnoremap <silent><buffer><expr>j line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr>k line('.') == 1 ? 'G' : 'k'
endfunction

function! CheckBackSpace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" }}}
" ================ Custom mappings ======================== {{{

" Comment map
nmap <silent><Leader>c :call Comment()<CR>
" Line comment command
xmap <silent><Leader>c :<C-u>call Comment(1)<CR>
" Map save to Ctrl + S
map <c-s> :w<CR>
imap <c-s> <C-o>:w<CR>
nnoremap <Leader>s :w<CR>

" Open vertical split
nnoremap <Leader>v <C-w>v

" Move between slits
nnoremap <c-h> <C-w>h
nnoremap <c-j> <C-w>j
nnoremap <c-k> <C-w>k
nnoremap <c-l> <C-w>l
tnoremap <c-h> <C-\><C-n><C-w>h
tnoremap <c-l> <C-\><C-n><C-w>l
tnoremap <c-Space> <C-\><C-n><C-w>p

" Down is really the next line
nnoremap j gj
nnoremap k gk

inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : CheckBackSpace() ? "\<TAB>" : "\<C-n>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-Tab>"

inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}
inoremap        (  ()<Left>
inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
inoremap        [  []<Left>
inoremap <expr> ]  strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == '"' ? "\<Right>" : "\"\"\<Left>"

" Map for Escape key
inoremap jj <Esc>
tnoremap <Leader>jj <C-\><C-n>

" Yank to the end of the line
nnoremap Y y$

" Copy to system clipboard
vnoremap <C-c> "+y
" Paste from system clipboard with Ctrl + v
inoremap <C-v> <Esc>"+p
nnoremap <Leader>p "0p
vnoremap <Leader>p "0p
nnoremap <Leader>h viw"0p

" Move to the end of yanked text after yank and paste
nnoremap p p`]
vnoremap y y`]
vnoremap p p`]
" Select last pasted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Move selected lines up and down
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Clear search highlight
nnoremap <Leader><space> :noh<CR>

" Handle ale error window
nnoremap <Leader>e :lopen<CR>
nnoremap <Leader>E :copen<CR>

nnoremap <silent><Leader>q :call CloseBuffer()<CR>
nnoremap <silent><Leader>Q :call CloseBuffer(1)<CR>

nnoremap <Leader>hf :Dirvish %<CR>
nnoremap <Leader>n :Dirvish<CR>

" Toggle between last 2 buffers
nnoremap <leader><tab> <c-^>

" Filesearch plugin map for searching in whole folder
nnoremap <Leader>f :call Search()<CR>
nnoremap <Leader>F :call Search(1)<CR>

" Toggle buffer list
nnoremap <Leader>b :ls<CR>

" Indenting in visual mode
xnoremap <s-tab> <gv
xnoremap <tab> >gv

nnoremap <C-p> :Files<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>t :BTags<CR>
nnoremap <Leader>m :History<CR>

"Disable ex mode mapping
map Q <Nop>

" Jump to definition in vertical split
nnoremap <Leader>] <C-W>v<C-]>

" Close all other buffers except current one
nnoremap <Leader>db :silent w <BAR> :silent %bd <BAR> e#<CR>

nnoremap gx :call netrw#BrowseX(expand('<cfile>'), netrw#CheckIfRemote())<CR>

" }}}
" ================ Plugins setups ======================== {{{

let g:dirvish_mode = ':sort ,^.*[\/],'                                          "List directories first in dirvish

let g:jsx_ext_required = 1                                                      "Force jsx extension for jsx filetype
let g:javascript_plugin_jsdoc = 1                                               "Enable syntax highlighting for js doc blocks

" }}}
" vim:foldenable:foldmethod=marker
