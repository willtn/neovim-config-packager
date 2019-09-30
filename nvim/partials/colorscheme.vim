let s:bg_color = $NVIM_COLORSCHEME_BG ==? 'light' ? 'light' : 'dark'
set termguicolors                                                               "Enable true colors
silent exe 'set background='.s:bg_color
set synmaxcol=300                                                               "Use syntax highlighting only for 300 columns

let g:gruvbox_material_enable_bold = 1

filetype plugin indent on
syntax on
silent! colorscheme gruvbox-material

augroup vimrc_colorscheme
  autocmd!
  autocmd Syntax,ColorScheme * call s:set_gruvbox_colors()
  autocmd BufEnter * :syntax sync fromstart
augroup END

function! s:set_gruvbox_colors() abort
  hi link ALEVirtualTextError Red
  hi link ALEVirtualTextWarning Yellow
  hi link ALEVirtualTextInfo Blue

  let g:fzf_colors = extend(get(g:, 'fzf_colors', {}), {
        \ 'fg': ['fg', 'GruvboxFg1'],
        \ 'bg': ['fg', 'GruvboxBg1'],
        \ 'fg+': ['fg', 'GruvboxFg2'],
        \ 'bg+': ['fg', 'GruvboxBg2'],
        \ })
endfunction
