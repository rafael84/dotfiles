-- ============================================================================
-- C Language Configuration
-- ============================================================================

-- ============================================================================
-- clangd - C/C++ Language Server
-- ============================================================================

local ok, lspconfig = pcall(require, 'lspconfig')
if not ok then
  return
end

-- Check if LSP globals are set
if not _G.lsp_on_attach or not _G.lsp_capabilities then
  return
end

-- Safely setup clangd (fails gracefully if clangd is not installed)
if vim.fn.executable('clangd') == 0 then
  return
end

-- Suppress error output during setup attempt
local old_notify = vim.notify
vim.notify = function() end

local setup_ok, err = pcall(function()
  lspconfig['clangd'].setup({
    on_attach = _G.lsp_on_attach,
    capabilities = _G.lsp_capabilities,
    cmd = {
      'clangd',
      '--background-index',
      '--clang-tidy',
      '--header-insertion=iwyu',
      '--completion-style=detailed',
      '--function-arg-placeholders',
      '--fallback-style=llvm',
    },
    init_options = {
      usePlaceholders = true,
      completeUnimported = true,
      clangdFileStatus = true,
    },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
    root_dir = lspconfig.util.root_pattern(
      '.clangd',
      '.clang-tidy',
      '.clang-format',
      'compile_commands.json',
      'compile_flags.txt',
      'configure.ac',
      '.git'
    ),
  })
end)

-- Restore notify
vim.notify = old_notify

if not setup_ok then
  return
end

-- ============================================================================
-- Helper Commands
-- ============================================================================

-- Command to generate .clang-format file
vim.api.nvim_create_user_command('CGenClangFormat', function()
  local cwd = vim.fn.getcwd()
  local filepath = cwd .. '/.clang-format'

  local content = [[---
BasedOnStyle: LLVM
IndentWidth: 4
TabWidth: 4
UseTab: Never
ColumnLimit: 120
BreakBeforeBraces: Allman
AllowShortFunctionsOnASingleLine: None
AllowShortIfStatementsOnASingleLine: Never
AllowShortLoopsOnASingleLine: false
IndentCaseLabels: false
]]

  local file = io.open(filepath, 'w')
  if not file then
    vim.notify('Failed to create .clang-format', vim.log.levels.ERROR)
    return
  end

  file:write(content)
  file:close()

  vim.notify('Created ' .. filepath, vim.log.levels.INFO)
  vim.notify('Restart LSP with :LspRestart to apply changes', vim.log.levels.INFO)
end, { desc = 'Generate .clang-format with 4 spaces' })

-- Command to generate compile_flags.txt for pkg-config libraries
vim.api.nvim_create_user_command('CGenCompileFlags', function(opts)
  local libs = opts.args
  if libs == '' then
    vim.notify('Usage: :CGenCompileFlags <library> [library2...]', vim.log.levels.ERROR)
    vim.notify('Example: :CGenCompileFlags raylib', vim.log.levels.INFO)
    return
  end

  -- Get flags from pkg-config
  local cmd = string.format('pkg-config --cflags --libs %s', libs)
  local handle = io.popen(cmd .. ' 2>&1')
  if not handle then
    vim.notify('Failed to run pkg-config', vim.log.levels.ERROR)
    return
  end

  local result = handle:read('*a')
  local exit_code = handle:close()

  if not exit_code then
    vim.notify('pkg-config failed: ' .. result, vim.log.levels.ERROR)
    return
  end

  -- Parse flags into lines (one flag per line)
  local flags = {}
  for flag in result:gmatch('%S+') do
    table.insert(flags, flag)
  end

  if #flags == 0 then
    vim.notify('No flags returned from pkg-config', vim.log.levels.WARN)
    return
  end

  -- Write to compile_flags.txt in current directory
  local cwd = vim.fn.getcwd()
  local filepath = cwd .. '/compile_flags.txt'
  local file = io.open(filepath, 'w')
  if not file then
    vim.notify('Failed to create compile_flags.txt', vim.log.levels.ERROR)
    return
  end

  for _, flag in ipairs(flags) do
    file:write(flag .. '\n')
  end
  file:close()

  vim.notify('Created ' .. filepath .. ' with ' .. #flags .. ' flags', vim.log.levels.INFO)
  vim.notify('Restart LSP with :LspRestart to apply changes', vim.log.levels.INFO)
end, {
  nargs = '+',
  desc = 'Generate compile_flags.txt from pkg-config',
  complete = 'file',
})

-- ============================================================================
-- C Autocommands and Keybindings
-- ============================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Format on save is handled by conform.nvim (formatting.lua)
-- No need for LSP format on save here

-- ============================================================================
-- Helper Functions
-- ============================================================================

-- Close any existing terminal buffers
local function close_terminal_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == 'terminal' then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

-- Find the binary target name from Makefile
local function get_makefile_binary()
  local makefile_name = vim.fn.filereadable('Makefile') == 1 and 'Makefile' or 'makefile'
  local makefile_lines = vim.fn.readfile(makefile_name)

  for _, line in ipairs(makefile_lines) do
    -- Match target: dependency (skip targets with dots like .PHONY)
    local target = line:match('^([^.][^:]*):')
    if target then
      return target:gsub('%s+', '') -- Remove whitespace
    end
  end

  return nil
end

-- Check if a Makefile exists
local function has_makefile()
  return vim.fn.filereadable('Makefile') == 1 or vim.fn.filereadable('makefile') == 1
end

-- Run terminal command and auto-close on success
local function run_term_with_autoclose(cmd)
  close_terminal_buffers()
  vim.cmd('split | term ' .. cmd)

  -- Auto-close terminal buffer on success
  vim.defer_fn(function()
    local term_buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_create_autocmd('TermClose', {
      buffer = term_buf,
      callback = function()
        local exit_code = vim.v.event.status
        if exit_code == 0 then
          vim.defer_fn(function()
            if vim.api.nvim_buf_is_valid(term_buf) then
              vim.api.nvim_buf_delete(term_buf, { force = true })
            end
          end, 500) -- Small delay to see the success message
        end
      end,
      once = true,
    })
  end, 10)
end

-- Run terminal command without auto-close
local function run_term(cmd)
  close_terminal_buffers()
  vim.cmd('split | term ' .. cmd)
end

-- ============================================================================
-- Keybindings
-- ============================================================================

autocmd('FileType', {
  group = augroup('CKeybindings', { clear = true }),
  pattern = { 'c', 'cpp' },
  callback = function()
    local opts = { buffer = true, noremap = true, silent = true }

    -- ============================================================================
    -- LSP and Configuration Commands
    -- ============================================================================

    -- Switch between source and header
    vim.keymap.set('n', '<Leader>a', ':ClangdSwitchSourceHeader<CR>',
      vim.tbl_extend('force', opts, { desc = 'Switch source/header' }))

    -- Generate .clang-format with 4 spaces
    vim.keymap.set('n', '<leader>cF', ':CGenClangFormat<CR>',
      vim.tbl_extend('force', opts, { desc = 'Generate .clang-format (4 spaces)' }))

    -- Generate compile_flags.txt for raylib (common use case)
    vim.keymap.set('n', '<leader>cf', ':CGenCompileFlags raylib<CR>',
      vim.tbl_extend('force', opts, { desc = 'Generate compile_flags.txt (raylib)' }))

    -- ============================================================================
    -- Build and Run Commands
    -- ============================================================================

    -- Build: Use Makefile if it exists, otherwise compile with gcc
    vim.keymap.set('n', '<leader>b', function()
      if has_makefile() then
        run_term_with_autoclose('make')
      else
        local file = vim.fn.expand('%')
        local binary = vim.fn.expand('%:r')
        run_term_with_autoclose('gcc -Wall -Wextra -g ' .. file .. ' -o ' .. binary)
      end
    end, vim.tbl_extend('force', opts, { desc = 'Build (auto-close on success)' }))

    -- Build (keep buffer open)
    vim.keymap.set('n', '<leader>B', function()
      if has_makefile() then
        run_term('make')
      else
        local file = vim.fn.expand('%')
        local binary = vim.fn.expand('%:r')
        run_term('gcc -Wall -Wextra -g ' .. file .. ' -o ' .. binary)
      end
    end, vim.tbl_extend('force', opts, { desc = 'Build (keep open)' }))

    -- Build and run
    vim.keymap.set('n', '<leader>r', function()
      if has_makefile() then
        local binary = get_makefile_binary()
        if binary and binary ~= '' then
          run_term_with_autoclose('make && ./' .. binary)
        else
          vim.notify('Could not find binary target in Makefile', vim.log.levels.WARN)
          run_term_with_autoclose('make')
        end
      else
        local file = vim.fn.expand('%')
        local binary = vim.fn.expand('%:r')
        run_term_with_autoclose('gcc -Wall -Wextra -g ' .. file .. ' -o ' .. binary .. ' && ./' .. binary)
      end
    end, vim.tbl_extend('force', opts, { desc = 'Build and run (auto-close on success)' }))

    -- Build and run (keep buffer open to see output)
    vim.keymap.set('n', '<leader>R', function()
      if has_makefile() then
        local binary = get_makefile_binary()
        if binary and binary ~= '' then
          run_term('make && ./' .. binary)
        else
          vim.notify('Could not find binary target in Makefile', vim.log.levels.WARN)
          run_term('make')
        end
      else
        local file = vim.fn.expand('%')
        local binary = vim.fn.expand('%:r')
        run_term('gcc -Wall -Wextra -g ' .. file .. ' -o ' .. binary .. ' && ./' .. binary)
      end
    end, vim.tbl_extend('force', opts, { desc = 'Build and run (keep open)' }))
  end,
})
