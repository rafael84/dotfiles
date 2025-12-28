-- ============================================================================
-- LSP Configuration - Base
-- ============================================================================

-- Suppress lspconfig deprecation warning and offset_encoding warning
local notify = vim.notify
vim.notify = function(msg, ...)
  if msg:match('lspconfig.*deprecated') then
    return
  end
  if msg:match('multiple different client offset_encodings') then
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

-- Mason installs and auto-enables servers, except those we configure manually
require('mason-lspconfig').setup({
  ensure_installed = {
    'pyright',
    'ruff',
    'ts_ls',
    'eslint',
    'bashls',
    'gopls',
    'clangd',
    'clojure_lsp',
    'jsonls',
    'html',
    'cssls',
  },
  automatic_installation = true,
  -- Exclude servers that are manually configured in language-specific files
  automatic_enable = {
    exclude = { 'pyright', 'ruff', 'ts_ls', 'eslint', 'clangd', 'gopls' }
  },
})

-- Simple servers (bashls, gopls, etc.) are auto-enabled by mason-lspconfig
-- Python (pyright, ruff) and JS (ts_ls, eslint) are configured in language-specific files

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

  -- Open hover documentation in a split buffer (instead of floating window)
  vim.keymap.set('n', '<leader>K', function()
    local params = vim.lsp.util.make_position_params()
    vim.lsp.buf_request(0, 'textDocument/hover', params, function(err, result, ctx, config)
      if err or not result or not result.contents then
        vim.notify('No documentation available', vim.log.levels.INFO)
        return
      end

      -- Create a new vertical split
      vim.cmd('vnew')
      local buf = vim.api.nvim_get_current_buf()

      -- Set buffer options
      vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf })
      vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })
      vim.api.nvim_set_option_value('swapfile', false, { buf = buf })
      vim.api.nvim_set_option_value('filetype', 'markdown', { buf = buf })
      vim.api.nvim_buf_set_name(buf, 'LSP Documentation')

      -- Convert hover result to lines
      local lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
      lines = vim.lsp.util.trim_empty_lines(lines)

      -- Set the content
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.api.nvim_set_option_value('modifiable', false, { buf = buf })

      -- Add keybinding to close the buffer easily
      vim.keymap.set('n', 'q', ':q<CR>', { buffer = buf, noremap = true, silent = true })
    end)
  end, opts)

  -- Actions
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('v', '<leader>ca', vim.lsp.buf.code_action, opts)  -- Code actions on selection
  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)
  vim.keymap.set('v', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)  -- Format selection

  -- Diagnostics
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
end

-- LSP Capabilities (for nvim-cmp)
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Set consistent position encoding to avoid warnings
capabilities.general = capabilities.general or {}
capabilities.general.positionEncodings = { 'utf-16' }

-- Export for use in language-specific configs
_G.lsp_on_attach = on_attach
_G.lsp_capabilities = capabilities

-- ============================================================================
-- Diagnostic Signs and Configuration
-- ============================================================================

vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    spacing = 4,
    -- Show error code in noqa-friendly format
    format = function(diagnostic)
      local code = diagnostic.code or ''
      local source = diagnostic.source or ''

      -- For Ruff errors, show code first (for easy noqa usage)
      if source:lower():match('ruff') and code ~= '' then
        return string.format('[%s] %s', code, diagnostic.message)
      -- For other sources (pyright, etc), show source name
      elseif source ~= '' and code ~= '' then
        return string.format('%s [%s]: %s', source, code, diagnostic.message)
      elseif code ~= '' then
        return string.format('[%s]: %s', code, diagnostic.message)
      elseif source ~= '' then
        return string.format('%s: %s', source, diagnostic.message)
      end

      return diagnostic.message
    end,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '❗',
      [vim.diagnostic.severity.WARN] = '⚠️',
      [vim.diagnostic.severity.INFO] = 'ℹ️',
      [vim.diagnostic.severity.HINT] = '💡',
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
    -- Show error code in noqa-friendly format
    format = function(diagnostic)
      local code = diagnostic.code or ''
      local source = diagnostic.source or ''

      -- For Ruff errors, show code first (for easy noqa usage)
      if source:lower():match('ruff') and code ~= '' then
        return string.format('[%s] %s\n\nTo suppress: # noqa: %s', code, diagnostic.message, code)
      -- For other sources (pyright, etc), show source name
      elseif source ~= '' and code ~= '' then
        return string.format('%s [%s]: %s', source, code, diagnostic.message)
      elseif code ~= '' then
        return string.format('[%s]: %s', code, diagnostic.message)
      elseif source ~= '' then
        return string.format('%s: %s', source, diagnostic.message)
      end

      return diagnostic.message
    end,
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
