"------------------------------------------------------------------------------
" Text, tab and indent related
"------------------------------------------------------------------------------

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Round indent to multiple of 'shiftwidth' for > and < commands
set shiftround

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set nowrap "Don't Wrap lines (it is stupid)

" Indent/unindent highlighted block (and maintain highlight)
vnoremap <Tab>    >gv
vnoremap <S-Tab>  <gv

" for json files, 2 spaces
autocmd Filetype json setlocal ts=2 sw=2 sts=0 expandtab

augroup json_base
  au!
  autocmd BufNewFile,BufRead *.json.base  set ft=json
augroup END
