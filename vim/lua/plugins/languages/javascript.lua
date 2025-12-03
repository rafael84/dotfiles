-- ============================================================================
-- JavaScript/TypeScript Language Configuration
-- ============================================================================

local ok, lspconfig = pcall(require, 'lspconfig')
if not ok then
  return
end

-- Check if LSP globals are set
if not _G.lsp_on_attach or not _G.lsp_capabilities then
  return
end

-- ============================================================================
-- TypeScript/JavaScript LSP (ts_ls)
-- ============================================================================

pcall(function()
  lspconfig.ts_ls.setup({
  on_attach = _G.lsp_on_attach,
  capabilities = _G.lsp_capabilities,
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx'
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
end)

-- ============================================================================
-- ESLint LSP - Linting and Auto-fix
-- ============================================================================

pcall(function()
  lspconfig.eslint.setup({
    on_attach = function(client, bufnr)
      -- Enable auto-fix on save
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        command = 'EslintFixAll',
      })
      _G.lsp_on_attach(client, bufnr)
    end,
    capabilities = _G.lsp_capabilities,
  })
end)

-- ============================================================================
-- JSON LSP - For package.json, tsconfig.json, etc.
-- ============================================================================

pcall(function()
  lspconfig.jsonls.setup({
    on_attach = _G.lsp_on_attach,
    capabilities = _G.lsp_capabilities,
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
      },
    },
  })
end)

-- ============================================================================
-- HTML LSP
-- ============================================================================

pcall(function()
  lspconfig.html.setup({
    on_attach = _G.lsp_on_attach,
    capabilities = _G.lsp_capabilities,
  })
end)

-- ============================================================================
-- CSS LSP
-- ============================================================================

pcall(function()
  lspconfig.cssls.setup({
    on_attach = _G.lsp_on_attach,
    capabilities = _G.lsp_capabilities,
  })
end)
