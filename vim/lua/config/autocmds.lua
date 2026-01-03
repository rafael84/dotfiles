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
    vim.cmd('wincmd J')
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
-- C/C++ Header Files
-- ============================================================================

-- Ensure .h files are detected as C (not cpp)
autocmd({ 'BufNewFile', 'BufRead' }, {
  group = augroup('CHeaders', { clear = true }),
  pattern = '*.h',
  command = 'set filetype=c',
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

-- ============================================================================
-- Project-Local Configuration
-- ============================================================================

-- Helper function to load .nvim.lua config
_G.load_nvim_config = function(silent)
  -- Get current buffer's directory
  local buf_dir = vim.fn.expand('%:p:h')

  -- If no file is open, use cwd
  if buf_dir == '' or buf_dir == '.' then
    buf_dir = vim.fn.getcwd()
  end

  -- First, try to load from project root
  local root_markers = { '.git', 'Makefile', 'makefile' }
  local project_root = nil

  for _, marker in ipairs(root_markers) do
    local found = vim.fn.finddir(marker, buf_dir .. ';')
    if found ~= '' then
      project_root = vim.fn.fnamemodify(found, ':h')
      break
    end
    local found_file = vim.fn.findfile(marker, buf_dir .. ';')
    if found_file ~= '' then
      project_root = vim.fn.fnamemodify(found_file, ':h')
      break
    end
  end

  -- Load project root config first (if exists)
  if project_root then
    local root_config = project_root .. '/.nvim.lua'
    if vim.fn.filereadable(root_config) == 1 then
      local ok, err = pcall(dofile, root_config)
      if not ok then
        vim.notify('Error in ' .. root_config .. ': ' .. tostring(err), vim.log.levels.ERROR)
      end
    end
  end

  -- Then load local directory config (overrides root config)
  local local_config = buf_dir .. '/.nvim.lua'
  local root_config_path = project_root and (project_root .. '/.nvim.lua') or nil

  if vim.fn.filereadable(local_config) == 1 and local_config ~= root_config_path then
    local ok, err = pcall(dofile, local_config)
    if not ok then
      vim.notify('Error in ' .. local_config .. ': ' .. tostring(err), vim.log.levels.ERROR)
    end
  end
end

-- Create the augroup once
local project_config_group = augroup('ProjectConfig', { clear = true })

-- Load on startup (with delay to ensure buffer is loaded)
autocmd('VimEnter', {
  group = project_config_group,
  pattern = '*',
  callback = function()
    vim.defer_fn(load_nvim_config, 100)
  end,
})

-- Load when a file is read
autocmd('BufReadPost', {
  group = project_config_group,
  pattern = '*',
  callback = function()
    if vim.bo.buftype == '' then
      load_nvim_config()
    end
  end,
})

-- Reload when switching between buffers (for different subdirectories)
autocmd('BufEnter', {
  group = project_config_group,
  pattern = '*.c,*.h,*.cpp,*.hpp',
  callback = function()
    if vim.bo.buftype == '' then
      load_nvim_config(true)  -- silent to avoid notification spam
    end
  end,
})

-- Also reload when changing directory
autocmd('DirChanged', {
  group = project_config_group,
  pattern = '*',
  callback = load_nvim_config,
})

-- Command to manually reload project config
vim.api.nvim_create_user_command('ProjectConfigReload', function()
  load_nvim_config()
end, { desc = 'Reload project-local .nvim.lua configuration' })

-- Command to show current C build settings
vim.api.nvim_create_user_command('ProjectConfigShow', function()
  local target = vim.g.c_make_target or '(not set)'
  local binary = vim.g.c_binary_path or '(not set)'
  local args = vim.g.c_binary_args or '(not set)'

  print('=== C Build Configuration ===')
  print('Make target: ' .. target)
  print('Binary path: ' .. binary)
  print('Binary args: ' .. args)
end, { desc = 'Show current C build configuration' })
