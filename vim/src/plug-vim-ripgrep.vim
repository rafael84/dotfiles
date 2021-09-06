"------------------------------------------------------------------------------
" Plug 'jremmen/vim-ripgrep'
"------------------------------------------------------------------------------
let g:rg_highlight = 1
let g:rg_derive_root = 1

nnoremap <silent> g* :Rg <CR>
vnoremap <silent> g* :call RgVisual() <CR>
