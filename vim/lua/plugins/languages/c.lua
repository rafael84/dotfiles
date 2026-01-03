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
      '.git',
      '.clangd',
      '.clang-tidy',
      '.clang-format',
      'compile_commands.json',
      'compile_flags.txt',
      'configure.ac'
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
-- C Build/Run Helper Functions
-- ============================================================================

local M = {}

-- Helper function to load CFLAGS from compile_flags.txt
function M.get_cflags()
  local cflags = ''
  if vim.fn.filereadable('compile_flags.txt') == 1 then
    local flags = vim.fn.readfile('compile_flags.txt')
    cflags = table.concat(flags, ' ')
  end
  return cflags
end

-- Close any existing terminal buffers
function M.close_terminal_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == 'terminal' then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

-- Get list of Makefile targets
function M.get_makefile_targets()
  local makefile_name = vim.fn.filereadable('Makefile') == 1 and 'Makefile' or 'makefile'
  if vim.fn.filereadable(makefile_name) == 0 then
    return {}
  end

  local makefile_lines = vim.fn.readfile(makefile_name)
  local targets = {}

  for _, line in ipairs(makefile_lines) do
    -- Match target: dependency (skip .PHONY and targets with dots/special chars)
    local target = line:match('^([%w_-]+)%s*:')
    if target and not vim.tbl_contains(targets, target) then
      table.insert(targets, target)
    end
  end

  return targets
end

-- Find the binary target name from Makefile
function M.get_makefile_binary()
  -- First check if project-local variable is set
  if vim.g.c_binary_path then
    return vim.g.c_binary_path
  end

  local makefile_name = vim.fn.filereadable('Makefile') == 1 and 'Makefile' or 'makefile'
  if vim.fn.filereadable(makefile_name) == 0 then
    return nil
  end

  local makefile_lines = vim.fn.readfile(makefile_name)

  for _, line in ipairs(makefile_lines) do
    -- Match output binary in -o flag (e.g., "gcc ... -o bin/tiny16")
    local binary = line:match('%-o%s+([^%s]+)')
    if binary then
      return binary
    end
  end

  return nil
end

-- Run terminal command and auto-close on success
function M.run_term_with_autoclose(cmd)
  M.close_terminal_buffers()
  vim.cmd('split | term ' .. cmd)

  -- Set filetype to 'cterm' for the terminal buffer
  vim.bo.filetype = 'cterm'

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
function M.run_term(cmd)
  M.close_terminal_buffers()
  vim.cmd('split | term ' .. cmd)

  -- Set filetype to 'cterm' for the terminal buffer
  vim.bo.filetype = 'cterm'
end

-- Select build target (interactive)
function M.select_build_target()
  local targets = M.get_makefile_targets()
  if #targets == 0 then
    vim.notify('No Makefile targets found', vim.log.levels.WARN)
    return
  end

  vim.ui.select(targets, {
    prompt = 'Select make target:',
  }, function(choice)
    if choice then
      vim.g.c_make_target = choice
      vim.notify('Set make target to: ' .. choice, vim.log.levels.INFO)
    end
  end)
end

-- Select binary to run (interactive)
function M.select_binary_path()
  vim.ui.input({
    prompt = 'Binary path: ',
    default = vim.g.c_binary_path or 'bin/',
  }, function(input)
    if input and input ~= '' then
      vim.g.c_binary_path = input
      vim.notify('Set binary path to: ' .. input, vim.log.levels.INFO)
    end
  end)
end

-- Build only (uses quickfix for errors)
function M.build()
  vim.cmd('write')
  -- Clear previous quickfix list
  vim.fn.setqflist({})

  if vim.fn.filereadable('Makefile') == 1 then
    local target = vim.g.c_make_target or ''
    if target ~= '' then
      vim.cmd('silent! make! ' .. target)
    else
      vim.cmd('silent! make!')
    end
  else
    local file = vim.fn.expand('%')
    local binary = vim.fn.expand('%:r')
    local cflags = M.get_cflags()
    vim.o.makeprg = 'gcc -Wall -Wextra -g ' .. cflags .. ' ' .. file .. ' -o ' .. binary
    vim.cmd('silent! make!')
  end

  -- Redraw screen to clear any prompts
  vim.cmd('redraw!')

  -- Check quickfix list after a brief delay to ensure it's populated
  vim.defer_fn(function()
    local qflist = vim.fn.getqflist()
    -- Filter for actual errors (entries with valid bufnr or type)
    local has_errors = false
    for _, item in ipairs(qflist) do
      if item.valid == 1 and item.bufnr > 0 then
        has_errors = true
        break
      end
    end

    if has_errors then
      -- Build failed, open quickfix
      vim.cmd('copen')
    else
      -- Build successful, close quickfix
      vim.cmd('cclose')
      local target_msg = vim.g.c_make_target and (' [' .. vim.g.c_make_target .. ']') or ''
      vim.notify('Build successful!' .. target_msg, vim.log.levels.INFO)
    end
  end, 50)
end

-- Build and run (uses quickfix for build errors)
function M.build_and_run()
  vim.cmd('write')
  -- Clear previous quickfix list
  vim.fn.setqflist({})

  local has_makefile = vim.fn.filereadable('Makefile') == 1

  if has_makefile then
    local target = vim.g.c_make_target or ''
    if target ~= '' then
      vim.cmd('silent! make! ' .. target)
    else
      vim.cmd('silent! make!')
    end
  else
    local file = vim.fn.expand('%')
    local binary = vim.fn.expand('%:r')
    local cflags = M.get_cflags()
    vim.o.makeprg = 'gcc -Wall -Wextra -g ' .. cflags .. ' ' .. file .. ' -o ' .. binary
    vim.cmd('silent! make!')
  end

  -- Redraw screen to clear any prompts
  vim.cmd('redraw!')

  -- Check quickfix list after a brief delay to ensure it's populated
  vim.defer_fn(function()
    local qflist = vim.fn.getqflist()
    -- Filter for actual errors (entries with valid bufnr or type)
    local has_errors = false
    for _, item in ipairs(qflist) do
      if item.valid == 1 and item.bufnr > 0 then
        has_errors = true
        break
      end
    end

    if has_errors then
      -- Build failed, open quickfix
      vim.cmd('copen')
    else
      -- Build succeeded, close quickfix and run
      vim.cmd('cclose')
      if has_makefile then
        local binary = M.get_makefile_binary()
        if binary and binary ~= '' then
          local args = vim.g.c_binary_args or ''
          local cmd = './' .. binary
          if args ~= '' then
            cmd = cmd .. ' ' .. args
          end
          M.run_term(cmd)
        else
          vim.notify('No binary path set. Use <leader>rs to set it.', vim.log.levels.WARN)
        end
      else
        local binary = vim.fn.expand('%:r')
        local args = vim.g.c_binary_args or ''
        local cmd = './' .. binary
        if args ~= '' then
          cmd = cmd .. ' ' .. args
        end
        M.run_term(cmd)
      end
    end
  end, 50)
end

return M
