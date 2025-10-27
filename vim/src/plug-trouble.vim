"------------------------------------------------------------------------------
" Trouble.nvim - Better Diagnostics UI
"------------------------------------------------------------------------------

lua << EOF
require("trouble").setup({
  icons = true,
  fold_open = "▾",
  fold_closed = "▸",
  indent_lines = true,
  signs = {
    error = "❗",
    warning = "⚠️",
    hint = "💡",
    information = "ℹ️",
  },
  use_diagnostic_signs = true,
})
EOF

" Keybindings
nnoremap <leader>xx :Trouble diagnostics toggle<CR>
nnoremap <leader>xw :Trouble diagnostics toggle filter.buf=0<CR>
nnoremap <leader>xq :Trouble quickfix toggle<CR>
nnoremap <leader>xl :Trouble loclist toggle<CR>
nnoremap <leader>xr :Trouble lsp_references toggle<CR>
