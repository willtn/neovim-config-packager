augroup vimrc_sql
  autocmd!
  autocmd FileType sql setlocal equalprg=pg_format
  autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni
augroup END
