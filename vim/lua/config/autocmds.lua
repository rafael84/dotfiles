-- ============================================================================
-- Autocommands
-- ============================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ============================================================================
-- Return to Last Edit Position
-- ============================================================================

autocmd('BufReadPost', {
  group = augroup('LastPosition', { clear = true }),
  pattern = '*',
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

-- ============================================================================
-- Remove Trailing Whitespace
-- ============================================================================

autocmd('BufWritePre', {
  group = augroup('TrimWhitespace', { clear = true }),
  pattern = '*',
  command = [[%s/\s\+$//e]],
})

-- ============================================================================
-- Center Cursor Vertically
-- ============================================================================

autocmd({ 'BufEnter', 'WinEnter', 'WinNew', 'VimResized' }, {
  group = augroup('VCenterCursor', { clear = true }),
  pattern = '*',
  callback = function()
    vim.opt_local.scrolloff = math.floor(vim.fn.winheight(vim.fn.win_getid()) / 2)
  end,
})

-- ============================================================================
-- Quickfix Window Settings
-- ============================================================================

autocmd('FileType', {
  group = augroup('QuickFix', { clear = true }),
  pattern = 'qf',
  callback = function()
    vim.opt_local.wrap = false
    vim.cmd('wincmd L')
  end,
})

-- ============================================================================
-- JSON Settings
-- ============================================================================

autocmd('FileType', {
  group = augroup('JSON', { clear = true }),
  pattern = 'json',
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 0
    vim.opt_local.expandtab = true
  end,
})

-- Treat .json.base files as JSON
autocmd({ 'BufNewFile', 'BufRead' }, {
  group = augroup('JSONBase', { clear = true }),
  pattern = '*.json.base',
  command = 'set filetype=json',
})

-- ============================================================================
-- Highlight Trailing Whitespace
-- ============================================================================

autocmd({ 'BufWinEnter', 'InsertLeave' }, {
  group = augroup('TrailingWhitespace', { clear = true }),
  pattern = '*',
  command = [[match ExtraWhitespace /\s\+$/]],
})

autocmd('InsertEnter', {
  group = augroup('TrailingWhitespace', {}),
  pattern = '*',
  command = [[match ExtraWhitespace /\s\+\%#\@<!$/]],
})

autocmd('BufWinLeave', {
  group = augroup('TrailingWhitespace', {}),
  pattern = '*',
  callback = function()
    vim.fn.clearmatches()
  end,
})

-- Highlight definition
vim.api.nvim_set_hl(0, 'ExtraWhitespace', { bg = 'red', fg = 'red' })

-- ============================================================================
-- AnsiEsc in Quickfix
-- ============================================================================

autocmd('FileType', {
  group = augroup('AnsiEscQuickFix', { clear = true }),
  pattern = 'qf',
  command = 'silent! :AnsiEsc',
})
