-- ============================================================================
-- LSP Configuration - Base
-- ============================================================================

-- Suppress lspconfig deprecation warning
local notify = vim.notify
vim.notify = function(msg, ...)
  if msg:match('lspconfig.*deprecated') then
    return
  end
  notify(msg, ...)
end

-- ============================================================================
-- Mason - LSP/Formatter/Linter Installer
-- ============================================================================

require('mason').setup({
  ui = {
    icons = {
      package_installed = '✓',
      package_pending = '➜',
      package_uninstalled = '✗'
    }
  }
})

require('mason-lspconfig').setup({
  ensure_installed = {
    -- Python
    'pyright',
    'ruff',

    -- JavaScript/TypeScript
    'ts_ls',
    'eslint',

    -- Shell
    'bashls',

    -- Other languages
    'gopls',
    'clojure_lsp',
    'jsonls',
    'html',
    'cssls',
  },
  automatic_installation = true,
})

-- ============================================================================
-- LSP Keybindings and Capabilities
-- ============================================================================

local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }

  -- Navigation
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'gtd', vim.lsp.buf.type_definition, opts)

  -- Documentation
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

  -- Actions
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)

  -- Diagnostics
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
end

-- LSP Capabilities (for nvim-cmp)
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Export for use in language-specific configs
_G.lsp_on_attach = on_attach
_G.lsp_capabilities = capabilities

-- ============================================================================
-- Diagnostic Signs and Configuration
-- ============================================================================

vim.fn.sign_define('DiagnosticSignError', { text = '❗', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '⚠️', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = 'ℹ️', texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = '💡', texthl = 'DiagnosticSignHint' })

vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    spacing = 4,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

-- ============================================================================
-- nvim-lint - Additional Linting
-- ============================================================================

require('lint').linters_by_ft = {
  -- Most linting is handled by LSP
  -- Add custom linters here if needed
}

-- Lint on file save
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  callback = function()
    local linters = require('lint').linters_by_ft[vim.bo.filetype] or {}
    if #linters > 0 then
      require('lint').try_lint()
    end
  end,
})
