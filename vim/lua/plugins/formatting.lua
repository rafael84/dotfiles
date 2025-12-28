-- ============================================================================
-- conform.nvim - Code Formatting
-- ============================================================================

require('conform').setup({
  formatters_by_ft = {
    -- Python
    python = function(bufnr)
      return { 'ruff_format', 'ruff_organize_imports' }
    end,

    -- JavaScript/TypeScript
    javascript = { 'prettier' },
    javascriptreact = { 'prettier' },
    typescript = { 'prettier' },
    typescriptreact = { 'prettier' },

    -- Web
    html = { 'prettier' },
    css = { 'prettier' },
    scss = { 'prettier' },
    json = { 'prettier' },
    jsonc = { 'prettier' },
    yaml = { 'prettier' },
    markdown = { 'prettier' },

    -- Shell
    sh = { 'shfmt' },
    bash = { 'shfmt' },
    zsh = { 'shfmt' },

    -- Go (gopls handles formatting via LSP, but these are fallbacks)
    go = { 'gofumpt', 'goimports' },

    -- C/C++
    c = { 'clang_format' },
    cpp = { 'clang_format' },

    -- Lua
    lua = { 'stylua' },
  },

  -- Format on save
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },

  formatters = {
    shfmt = {
      prepend_args = { '-i', '2', '-ci' }, -- 2 spaces, indent switch cases
    },
    ruff_format = {
      command = 'ruff',
      args = { 'format', '--stdin-filename', '$FILENAME', '-' },
    },
    ruff_organize_imports = {
      command = 'ruff',
      args = { 'check', '--select', 'I', '--fix', '--stdin-filename', '$FILENAME', '-' },
    },
    clang_format = {
      command = 'clang-format',
      args = {
        '--style={BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, UseTab: Never, ColumnLimit: 100}',
      },
    },
  },
})

-- Command to format current buffer
vim.api.nvim_create_user_command('Format', function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ['end'] = { args.line2, end_line:len() },
    }
  end
  require('conform').format({ async = true, lsp_fallback = true, range = range })
end, { range = true })

-- Keybinding for manual format
vim.keymap.set('n', '<leader>fm', ':Format<CR>', { noremap = true, silent = true })
vim.keymap.set('v', '<leader>fm', ':Format<CR>', { noremap = true, silent = true })
