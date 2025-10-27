"------------------------------------------------------------------------------
" JavaScript/TypeScript LSP Configuration
"------------------------------------------------------------------------------

lua << EOF
-- TypeScript/JavaScript LSP
require('lspconfig').ts_ls.setup({
  on_attach = _G.lsp_on_attach,
  capabilities = _G.lsp_capabilities,
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx"
  },
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      }
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      }
    }
  }
})

-- ESLint LSP
require('lspconfig').eslint.setup({
  on_attach = function(client, bufnr)
    -- Enable auto-fix on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
    _G.lsp_on_attach(client, bufnr)
  end,
  capabilities = _G.lsp_capabilities,
})

-- JSON LSP (useful for package.json, tsconfig.json, etc.)
require('lspconfig').jsonls.setup({
  on_attach = _G.lsp_on_attach,
  capabilities = _G.lsp_capabilities,
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})

-- HTML LSP
require('lspconfig').html.setup({
  on_attach = _G.lsp_on_attach,
  capabilities = _G.lsp_capabilities,
})

-- CSS LSP
require('lspconfig').cssls.setup({
  on_attach = _G.lsp_on_attach,
  capabilities = _G.lsp_capabilities,
})
EOF
