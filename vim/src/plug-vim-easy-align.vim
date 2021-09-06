"------------------------------------------------------------------------------
" Plug 'junegunn/vim-easy-align'
"------------------------------------------------------------------------------

" Start interactive EasyAlign in visual mode
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

let g:easy_align_delimiters = {
\ '[': {
\     'pattern':       '[\[]',
\     'left_margin':   1,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ '(': {
\     'pattern':       '[\(]',
\     'left_margin':   1,
\     'right_margin':  0,
\     'stick_to_left': 0
\   }
\ }
