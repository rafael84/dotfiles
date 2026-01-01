-- ============================================================================
-- Diagnostics and UI Plugins
-- ============================================================================

-- ============================================================================
-- trouble.nvim - Better Diagnostics UI
-- ============================================================================

local status_ok, trouble = pcall(require, 'trouble')
if not status_ok then
  return
end

trouble.setup({
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

-- Keybindings are defined in config/keymaps.lua

-- ============================================================================
-- which-key.nvim - Show Keybindings
-- ============================================================================
-- WhichKey helps you remember your keymaps by showing available keybindings
-- in a popup as you type. It automatically detects most mappings and shows
-- them when you press a trigger key (like <leader>).
--
-- Features:
-- - Automatic keymap detection with <auto> trigger
-- - Built-in help for operators, motions, text-objects, windows, z, and g
-- - Shows marks when you hit ` or '
-- - Shows registers when you hit " (normal) or <C-r> (insert)
-- - Spelling suggestions with z=
--
-- Usage:
-- - Press <leader> in normal/visual mode to see all available keymaps
-- - Press any prefix key to drill down into groups
-- - Press <Esc> to cancel, <BS> to go back one level
-- - Press <C-d> / <C-u> to scroll the popup
--
-- Documentation: https://github.com/folke/which-key.nvim
-- ============================================================================

local status_ok2, wk = pcall(require, 'which-key')
if not status_ok2 then
  return
end

wk.setup({
  preset = 'modern', -- Use modern preset with better defaults

  -- Plugins configuration
  plugins = {
    marks = true,        -- shows a list of your marks on ' and `
    registers = true,    -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true,    -- enable spelling suggestions with z=
      suggestions = 20,  -- how many suggestions should be shown
    },
    presets = {
      operators = true,    -- adds help for operators like d, y, ...
      motions = true,      -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true,      -- default bindings on <c-w>
      nav = true,          -- misc bindings to work with windows
      z = true,            -- bindings for folds, spelling and others prefixed with z
      g = true,            -- bindings for prefixed with g
    },
  },

  -- Icon configuration - uses mini.icons or nvim-web-devicons
  icons = {
    breadcrumb = '»',  -- symbol used in the command line area that shows your active key combo
    separator = '➜',   -- symbol used between a key and its label
    group = '+',       -- symbol prepended to a group
    ellipsis = '…',
    -- Set to false to disable all mapping icons (both mini.icons and nvim-web-devicons)
    mappings = true,
    -- Use the icons from your Nerd Font
    rules = false,
    -- Use builtin icons (set this if you don't have a Nerd Font)
    -- rules = {},
    colors = true,
  },

  -- Window configuration
  win = {
    border = 'rounded',
    padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
    title = true,
    title_pos = 'center',
    zindex = 1000,
    -- Additional vim.wo and vim.bo options
    bo = {},
    wo = {
      winblend = 0, -- value between 0-100 for transparency
    },
  },

  layout = {
    width = { min = 20, max = 50 },
    height = { min = 4, max = 25 },
    spacing = 3, -- spacing between columns
    align = 'left',
  },

  -- Show key label on popup
  show_help = true,
  show_keys = true,

  -- Triggers to show the popup
  -- Automatically setup triggers
  triggers = {
    { '<auto>', mode = 'nixsotc' }, -- auto-generate triggers for all modes
    { '<leader>', mode = { 'n', 'v' } },
  },

  -- Delay before showing the which-key popup (in ms)
  -- Set to 0 for instant popup, higher for a delay
  delay = function(ctx)
    return ctx.plugin and 0 or 500
  end,

  -- You can add a custom filter to hide specific mappings
  filter = function(mapping)
    return true
  end,

  -- Key sorting (by default uses key comparison)
  sort = { 'local', 'order', 'group', 'alphanum', 'mod' },

  -- Expand builtin functions in descriptions
  expand = 0,

  -- Use <c-d> and <c-u> to scroll
  replace = {
    key = {
      function(key)
        return require('which-key.view').format(key)
      end,
    },
    desc = {
      { '<Plug>%(?(.*)%)?', '%1' },
      { '^%+', '' },
      { '<[cC]md>', '' },
      { '<[cC][rR]>', '' },
      { '<[sS]ilent>', '' },
      { '^lua%s+', '' },
      { '^call%s+', '' },
      { '^:%s*', '' },
    },
  },

  -- Disable WhichKey for specific filetypes
  disable = {
    ft = {},
    bt = {},
  },

  debug = false, -- enable wk.log in the current directory
})

-- Register leader key mappings with descriptions
wk.add({
  -- File operations
  { '<leader>f', group = 'File/Find' },
  { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Find files' },
  { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = 'Live grep' },
  { '<leader>fb', '<cmd>Telescope buffers<cr>', desc = 'Buffers' },
  { '<leader>fh', '<cmd>Telescope help_tags<cr>', desc = 'Help tags' },
  { '<leader>fr', '<cmd>Telescope oldfiles<cr>', desc = 'Recent files' },
  { '<leader>fc', '<cmd>Telescope commands<cr>', desc = 'Commands' },
  { '<leader>fs', '<cmd>Telescope lsp_document_symbols<cr>', desc = 'Document symbols',
    cond = function() return #vim.lsp.get_clients({ bufnr = 0 }) > 0 end },
  { '<leader>fw', '<cmd>Telescope lsp_workspace_symbols<cr>', desc = 'Workspace symbols',
    cond = function() return #vim.lsp.get_clients({ bufnr = 0 }) > 0 end },
  { '<leader>fd', '<cmd>Telescope diagnostics<cr>', desc = 'Diagnostics' },
  { '<leader>fm', '<cmd>Format<cr>', desc = 'Format buffer' },

  -- Dynamic buffer navigation with numbered keys
  -- Exclude for filetypes that use <leader>b for building (C, C++, Go, Python)
  { '<leader>b',
    group = function()
      local bufs = vim.fn.getbufinfo({ buflisted = 1 })
      return 'Buffers (' .. #bufs .. ')'
    end,
    expand = function()
      return require("which-key.extras").expand.buf()
    end,
    cond = function()
      local ft = vim.bo.filetype
      return not vim.tbl_contains({ 'c', 'cpp', 'go', 'python' }, ft)
    end
  },

  -- Dynamic window navigation
  { '<leader>W',
    group = function()
      local wins = vim.api.nvim_tabpage_list_wins(0)
      return 'Windows (' .. #wins .. ')'
    end,
    expand = function()
      return require("which-key.extras").expand.win()
    end
  },

  -- Save operations
  { '<leader>w', '<cmd>w<cr>', desc = 'Save file' },

  -- LSP (conditional - only show when LSP is active)
  { '<leader>l',
    group = function()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients == 0 then
        return 'LSP (inactive)'
      else
        return 'LSP (' .. clients[1].name .. ')'
      end
    end,
    cond = function() return #vim.lsp.get_clients({ bufnr = 0 }) > 0 end,
  },
  { '<leader>lr', vim.lsp.buf.rename, desc = 'Rename symbol',
    cond = function() return #vim.lsp.get_clients({ bufnr = 0 }) > 0 end },
  { '<leader>la', vim.lsp.buf.code_action, desc = 'Code action',
    cond = function() return #vim.lsp.get_clients({ bufnr = 0 }) > 0 end },
  { '<leader>lf', vim.lsp.buf.format, desc = 'Format',
    cond = function() return #vim.lsp.get_clients({ bufnr = 0 }) > 0 end },
  { '<leader>li', '<cmd>LspInfo<cr>', desc = 'LSP Info',
    cond = function() return #vim.lsp.get_clients({ bufnr = 0 }) > 0 end },

  -- Keep old mappings for compatibility
  -- Exclude for filetypes that use <leader>r for running (C, C++, Go, Python)
  { '<leader>r', group = 'Refactor',
    cond = function()
      local ft = vim.bo.filetype
      return not vim.tbl_contains({ 'c', 'cpp', 'go', 'python' }, ft)
    end
  },
  { '<leader>rn', vim.lsp.buf.rename, desc = 'Rename symbol' },
  { '<leader>c', group = 'Code' },
  { '<leader>ca', vim.lsp.buf.code_action, desc = 'Code action' },

  -- Diagnostics/Trouble (with dynamic count)
  { '<leader>x',
    group = function()
      local diagnostics = vim.diagnostic.get(0)
      local count = #diagnostics
      if count == 0 then
        return 'Diagnostics ✓'
      else
        return 'Diagnostics (' .. count .. ')'
      end
    end
  },
  { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Toggle diagnostics' },
  { '<leader>xw', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer diagnostics' },
  { '<leader>xq', '<cmd>Trouble quickfix toggle<cr>', desc = 'Quickfix list' },
  { '<leader>xl', '<cmd>Trouble loclist toggle<cr>', desc = 'Location list' },
  { '<leader>xr', '<cmd>Trouble lsp_references toggle<cr>', desc = 'LSP references' },
  { '<leader>xQ', function() vim.diagnostic.setqflist() end, desc = 'All diagnostics to quickfix' },
  { '<leader>xW', function() vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.WARN }) end, desc = 'Warnings to quickfix' },

  { '<leader>e', vim.diagnostic.open_float, desc = 'Show diagnostic' },
  { '<leader>q', vim.diagnostic.setloclist, desc = 'Diagnostics to loclist' },

  -- Git operations (conditional - only in git repos)
  { '<leader>g',
    group = 'Git',
    cond = function()
      return vim.fn.isdirectory('.git') == 1 or vim.fn.finddir('.git', '.;') ~= ''
    end
  },
  { '<leader>gh', '<cmd>GBrowse<cr>', desc = 'Open on GitHub', mode = { 'n', 'v' },
    cond = function()
      return vim.fn.isdirectory('.git') == 1 or vim.fn.finddir('.git', '.;') ~= ''
    end
  },
  { '<leader>gs', '<cmd>Git<cr>', desc = 'Git status',
    cond = function()
      return vim.fn.isdirectory('.git') == 1 or vim.fn.finddir('.git', '.;') ~= ''
    end
  },
  { '<leader>gc', '<cmd>Git commit<cr>', desc = 'Git commit',
    cond = function()
      return vim.fn.isdirectory('.git') == 1 or vim.fn.finddir('.git', '.;') ~= ''
    end
  },

  -- Utilities
  { '<leader>/', '<cmd>nohlsearch<cr>', desc = 'Clear search highlight' },
  { '<leader>m', desc = 'Remove Windows ^M' },
  { '<leader>M', '<cmd>Messages<cr>', desc = 'Show messages' },
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

-- Register K mappings (hover/help)
wk.add({
  { 'K', vim.lsp.buf.hover, desc = 'Hover documentation' },
})

-- Register zoom keybindings
wk.add({
  { 'Zz', '<c-w>_ | <c-w>|', desc = 'Zoom split' },
  { 'Zo', '<c-w>=', desc = 'Zoom out (equal splits)' },
})
