"------------------------------------------------------------------------------
" Go LSP Configuration (gopls)
"------------------------------------------------------------------------------

lua << EOF
-- Configure gopls (official Go language server)
require('lspconfig').gopls.setup({
  on_attach = _G.lsp_on_attach,
  capabilities = _G.lsp_capabilities,
  settings = {
    gopls = {
      -- Analysis settings
      analyses = {
        unusedparams = true,
        shadow = true,
        nilness = true,
        unusedwrite = true,
        useany = true,
      },

      -- Static check analyzers
      staticcheck = true,

      -- Code lens
      codelenses = {
        gc_details = true,
        generate = true,
        regenerate_cgo = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },

      -- Hints
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },

      -- Formatting
      gofumpt = true,  -- Stricter gofmt

      -- Organize imports
      ["local"] = "",  -- Set to your module path for local imports

      -- Completion
      usePlaceholders = true,
      completeUnimported = true,

      -- Experimental features
      experimentalPostfixCompletions = true,
    },
  },

  -- File types
  filetypes = { "go", "gomod", "gowork", "gotmpl" },

  -- Root directory detection
  root_dir = require('lspconfig').util.root_pattern("go.work", "go.mod", ".git"),
})
EOF

" Go-specific keybindings (in addition to standard LSP keybindings)
augroup GoLSP
  autocmd!

  " Format on save using gopls
  autocmd BufWritePre *.go lua vim.lsp.buf.format({ async = false })

  " Organize imports on save
  autocmd BufWritePre *.go lua vim.lsp.buf.code_action({
    \ context = { only = { 'source.organizeImports' } },
    \ apply = true
  \ })

  " Additional Go keybindings
  autocmd FileType go nnoremap <buffer> <leader>gt :lua vim.lsp.buf.type_definition()<CR>
  autocmd FileType go nnoremap <buffer> <leader>gi :lua vim.lsp.buf.implementation()<CR>
  autocmd FileType go nnoremap <buffer> <leader>gs :lua vim.lsp.buf.signature_help()<CR>
augroup END
