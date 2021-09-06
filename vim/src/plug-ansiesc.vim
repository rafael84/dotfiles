"------------------------------------------------------------------------------
" Plug 'vim-scripts/AnsiEsc.vim'
"------------------------------------------------------------------------------

augroup AnsiEscQuickFix
    autocmd!
    autocmd FileType qf silent! :AnsiEsc
augroup END
