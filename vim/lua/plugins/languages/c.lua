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

-- Format on save is handled by conform.nvim (formatting.lua)
-- Keybindings are defined in config/keymaps.lua
