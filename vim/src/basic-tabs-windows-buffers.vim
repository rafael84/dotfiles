"------------------------------------------------------------------------------
" Tabs, windows and buffers
"------------------------------------------------------------------------------

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

augroup quickfix
    autocmd!
    autocmd FileType qf setlocal nowrap
    autocmd FileType qf wincmd L
augroup END

" Remove 'set hidden'
set nohidden

" Zoom In and Zoom Out splits
noremap Zz <c-w>_ \| <c-w>\|
noremap Zo <c-w>=
