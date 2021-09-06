"------------------------------------------------------------------------------
" Plug 'tpope/vim-fireplace'
"------------------------------------------------------------------------------
nmap rr :Require<cr>
nmap ee :Eval<cr>

augroup clojure
  au Syntax clojure nmap <buffer> gd <Plug>FireplaceDjump
augroup END
