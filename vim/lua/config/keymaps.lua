-- ============================================================================
-- Base Keymaps
-- ============================================================================
-- This file contains basic keymaps that don't depend on plugins.
-- Plugin-specific keymaps are in their respective plugin config files.

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ============================================================================
-- General
-- ============================================================================

-- ; to : in normal mode
map('n', ';', ':', { noremap = true })

-- jj to escape in insert mode
map('i', 'jj', '<Esc>', opts)

-- Disable JJJJ
map('n', 'JJJJ', '<nop>', opts)

-- ============================================================================
-- Saving
-- ============================================================================

map('n', '<Leader>w', ':w<CR>', opts)
map('i', '<Leader>w', '<ESC>:w<CR>', opts)
map('v', '<Leader>w', '<ESC><ESC>:w<CR>', opts)

-- ============================================================================
-- Movement
-- ============================================================================

-- Treat long lines as break lines
map('n', 'j', 'gj', opts)
map('n', 'k', 'gk', opts)

-- Window navigation
map('n', '<C-j>', '<C-W>j', opts)
map('n', '<C-k>', '<C-W>k', opts)
map('n', '<C-h>', '<C-W>h', opts)
map('n', '<C-l>', '<C-W>l', opts)

-- Center screen when moving
map('n', '<C-d>', '<C-d>zz', opts)
map('n', '<C-u>', '<C-u>zz', opts)
map('n', 'n', 'nzzzv', opts)
map('n', 'N', 'Nzzzv', opts)

-- ============================================================================
-- Editing
-- ============================================================================

-- Visual shifting (stay in visual mode)
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)

-- Tab/Shift-Tab in visual mode
map('v', '<Tab>', '>gv', opts)
map('v', '<S-Tab>', '<gv', opts)

-- SPACE to exit visual mode
map('v', '<Space>', '<Esc>gV', opts)

-- Duplicate visual selection with Ctrl+P
map('v', '<C-p>', "y'>p", opts)

-- Move lines with Alt+j/k (Mac: Command+j/k)
map('n', '<M-j>', 'mz:m+<cr>`z', opts)
map('n', '<M-k>', 'mz:m-2<cr>`z', opts)
map('v', '<M-j>', ":m'>+<cr>`<my`>mzgv`yo`z", opts)
map('v', '<M-k>', ":m'<-2<cr>`>my`<mzgv`yo`z", opts)

if vim.fn.has('mac') == 1 or vim.fn.has('macunix') == 1 then
  map('n', '<D-j>', '<M-j>', opts)
  map('n', '<D-k>', '<M-k>', opts)
  map('v', '<D-j>', '<M-j>', opts)
  map('v', '<D-k>', '<M-k>', opts)
end

-- ============================================================================
-- Search
-- ============================================================================

-- Clear search highlighting
map('n', '<Leader>/', ':nohlsearch<CR>', opts)

-- ============================================================================
-- Misc
-- ============================================================================

-- Remove Windows ^M characters
map('n', '<Leader>m', 'mmHmt:%s/<C-V><cr>//ge<cr>\'tzt\'m', opts)

-- Disable q: (annoying command history window)
map('n', 'q:', ':q', opts)

-- Zoom splits
map('n', 'Zz', '<c-w>_ | <c-w>|', opts)
map('n', 'Zo', '<c-w>=', opts)

-- Open :messages in a buffer for easy copying
vim.api.nvim_create_user_command('Messages', function()
  local messages = vim.fn.execute('messages')
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(messages, '\n'))
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'filetype', 'messages')
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.cmd('vsplit')
  vim.api.nvim_win_set_buf(0, buf)
end, {})

map('n', '<Leader>M', ':Messages<CR>', opts)

-- ============================================================================
-- Function Keys
-- ============================================================================

-- F2: NERDTree toggle (defined in plugins/navigation.lua)
-- F3: Tagbar toggle (defined in plugins/navigation.lua)
