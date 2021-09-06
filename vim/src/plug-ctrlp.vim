"------------------------------------------------------------------------------
" Plug 'ctrlpvim/ctrlp.vim'
"------------------------------------------------------------------------------
let g:ctrlp_map = ''
nnoremap <C-p> <Esc>:CtrlP<CR>

let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_extensions = ['line']

if executable('rg')
    let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
endif
