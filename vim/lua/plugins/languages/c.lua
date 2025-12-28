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

-- Format on save
autocmd('BufWritePre', {
  group = augroup('CFormat', { clear = true }),
  pattern = { '*.c', '*.h', '*.cpp', '*.hpp' },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- C-specific keybindings
autocmd('FileType', {
  group = augroup('CKeybindings', { clear = true }),
  pattern = { 'c', 'cpp' },
  callback = function()
    local opts = { buffer = true, noremap = true, silent = true }

    -- Generate compile_flags.txt for raylib (common use case)
    vim.keymap.set('n', '<leader>cf', ':CGenCompileFlags raylib<CR>',
      vim.tbl_extend('force', opts, { desc = 'Generate compile_flags.txt (raylib)' }))

    -- Switch between source and header
    vim.keymap.set('n', '<Leader>a', ':ClangdSwitchSourceHeader<CR>',
      vim.tbl_extend('force', opts, { desc = 'Switch source/header' }))

    -- Compile current file
    vim.keymap.set('n', '<leader>b', function()
      local file = vim.fn.expand('%')
      vim.cmd('split | term gcc -Wall -Wextra -g ' .. file .. ' -o ' .. vim.fn.expand('%:r'))
    end, vim.tbl_extend('force', opts, { desc = 'Compile with gcc' }))

    -- Run compiled binary
    vim.keymap.set('n', '<leader>r', function()
      local binary = vim.fn.expand('%:r')
      -- Close any existing terminal buffers first
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buftype == 'terminal' then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
      vim.cmd('split | term ./' .. binary)
    end, vim.tbl_extend('force', opts, { desc = 'Run binary' }))
  end,
})
