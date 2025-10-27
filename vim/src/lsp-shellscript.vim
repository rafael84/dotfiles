"------------------------------------------------------------------------------
" ShellScript LSP Configuration
"------------------------------------------------------------------------------

lua << EOF
-- Bash Language Server
require('lspconfig').bashls.setup({
  on_attach = _G.lsp_on_attach,
  capabilities = _G.lsp_capabilities,
  filetypes = { "sh", "bash", "zsh" },
  settings = {
    bashIde = {
      globPattern = "*@(.sh|.inc|.bash|.command|.zsh)"
    }
  }
})
EOF
