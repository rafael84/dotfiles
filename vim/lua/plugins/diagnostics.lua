-- ============================================================================
-- Diagnostics and UI Plugins
-- ============================================================================

-- ============================================================================
-- trouble.nvim - Better Diagnostics UI
-- ============================================================================

require('trouble').setup({
  icons = true,
  fold_open = '▾',
  fold_closed = '▸',
  indent_lines = true,
  signs = {
    error = '❗',
    warning = '⚠️',
    hint = '💡',
    information = 'ℹ️',
  },
  use_diagnostic_signs = true,
})

-- Keybindings
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map('n', '<leader>xx', ':Trouble diagnostics toggle<CR>', opts)
map('n', '<leader>xw', ':Trouble diagnostics toggle filter.buf=0<CR>', opts)
map('n', '<leader>xq', ':Trouble quickfix toggle<CR>', opts)
map('n', '<leader>xl', ':Trouble loclist toggle<CR>', opts)
map('n', '<leader>xr', ':Trouble lsp_references toggle<CR>', opts)

-- ============================================================================
-- which-key.nvim - Show Keybindings
-- ============================================================================

local wk = require('which-key')

wk.setup({
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 20,
    },
    presets = {
      operators = true,
      motions = true,
      text_objects = true,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },
  icons = {
    breadcrumb = '»',
    separator = '➜',
    group = '+',
  },
  win = {
    border = 'rounded',
    padding = { 1, 2, 1, 2 },
  },
  show_help = true,
  show_keys = true,
  triggers = {
    { '<leader>', mode = 'n' },
    { '<leader>', mode = 'v' },
  },
  delay = 500,
})

-- Register leader key mappings with descriptions
wk.add({
  -- File operations
  { '<leader>f', group = 'File/Find' },
  { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Find files' },
  { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = 'Live grep' },
  { '<leader>fb', '<cmd>Telescope buffers<cr>', desc = 'Buffers' },
  { '<leader>fr', '<cmd>Telescope oldfiles<cr>', desc = 'Recent files' },
  { '<leader>fc', '<cmd>Telescope commands<cr>', desc = 'Commands' },
  { '<leader>fs', '<cmd>Telescope lsp_document_symbols<cr>', desc = 'Document symbols' },
  { '<leader>fw', '<cmd>Telescope lsp_workspace_symbols<cr>', desc = 'Workspace symbols' },
  { '<leader>fd', '<cmd>Telescope diagnostics<cr>', desc = 'Diagnostics' },
  { '<leader>fm', '<cmd>Format<cr>', desc = 'Format buffer' },

  -- LSP
  { '<leader>r', group = 'Refactor' },
  { '<leader>rn', vim.lsp.buf.rename, desc = 'Rename symbol' },

  { '<leader>c', group = 'Code' },
  { '<leader>ca', vim.lsp.buf.code_action, desc = 'Code action' },

  -- Diagnostics/Trouble
  { '<leader>x', group = 'Diagnostics' },
  { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Toggle diagnostics' },
  { '<leader>xw', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer diagnostics' },
  { '<leader>xq', '<cmd>Trouble quickfix toggle<cr>', desc = 'Quickfix list' },
  { '<leader>xl', '<cmd>Trouble loclist toggle<cr>', desc = 'Location list' },
  { '<leader>xr', '<cmd>Trouble lsp_references toggle<cr>', desc = 'LSP references' },

  { '<leader>e', vim.diagnostic.open_float, desc = 'Show diagnostic' },
  { '<leader>q', vim.diagnostic.setloclist, desc = 'Diagnostics to loclist' },
})

-- Register g mappings (go to)
wk.add({
  { 'g', group = 'Go to' },
  { 'gd', vim.lsp.buf.definition, desc = 'Go to definition' },
  { 'gD', vim.lsp.buf.declaration, desc = 'Go to declaration' },
  { 'gi', vim.lsp.buf.implementation, desc = 'Go to implementation' },
  { 'gr', vim.lsp.buf.references, desc = 'Show references' },
  { 'gtd', vim.lsp.buf.type_definition, desc = 'Type definition' },
})

-- Register [ and ] mappings (navigation)
wk.add({
  { '[', group = 'Previous' },
  { '[d', vim.diagnostic.goto_prev, desc = 'Previous diagnostic' },
  { '[m', desc = 'Previous function' },
  { '[[', desc = 'Previous class' },

  { ']', group = 'Next' },
  { ']d', vim.diagnostic.goto_next, desc = 'Next diagnostic' },
  { ']m', desc = 'Next function' },
  { ']]', desc = 'Next class' },
})
