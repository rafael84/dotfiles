"------------------------------------------------------------------------------
" Plug 'fatih/vim-go', { 'tag': '*' }
"------------------------------------------------------------------------------
" Note: LSP features (go-to-def, autocomplete, hover) are handled by gopls
" vim-go provides Go-specific commands: :GoBuild, :GoTest, :GoRun, etc.

" Disable LSP features (handled by gopls)
let g:go_def_mapping_enabled = 0           " Use LSP for gd
let g:go_code_completion_enabled = 0       " Use nvim-cmp with gopls
let g:go_gopls_enabled = 0                 " We configure gopls directly
let g:go_doc_keywordprg_enabled = 0        " Use LSP for K

" Disable formatting (handled by gopls via LSP)
let g:go_fmt_autosave = 0                  " LSP handles format on save
let g:go_imports_autosave = 0              " LSP handles organize imports

" Keep syntax highlighting (though Treesitter is better)
let g:go_highlight_build_constraints = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1

" Other settings
let g:go_echo_command_info = 1
let g:go_list_type = "quickfix"
let g:go_modifytags_transform = 'camelcase'
let g:go_autodetect_gopath = 1

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

augroup go
  autocmd!

  " Go-specific commands (not provided by LSP)
  autocmd FileType go nmap <silent> <Leader>a <Plug>(go-alternate-edit)
  autocmd FileType go nmap <silent> <Leader>c <Plug>(go-coverage-toggle)
  autocmd FileType go nmap <silent> <leader>b :<C-u>call <SID>build_go_files()<CR>
  autocmd FileType go nmap <silent> <leader>r <Plug>(go-run)
  autocmd FileType go nmap <silent> <leader>t <Plug>(go-test)
  autocmd FileType go nmap <silent> <leader>tf <Plug>(go-test-func)

  " Additional useful commands
  autocmd FileType go nmap <silent> <leader>gc <Plug>(go-callees)
  autocmd FileType go nmap <silent> <leader>gC <Plug>(go-callers)
  autocmd FileType go nmap <silent> <leader>gd <Plug>(go-describe)
  autocmd FileType go nmap <silent> <leader>ge <Plug>(go-iferr)
  autocmd FileType go nmap <silent> <leader>gf <Plug>(go-fill-struct)

  " Note: gd (go to definition), K (hover), gr (references) use LSP
  " Note: <leader>rn (rename) uses LSP
  " Note: Format and organize imports on save via LSP
augroup END
