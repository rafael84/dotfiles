-- ============================================================================
-- Python Language Configuration
-- ============================================================================

-- ============================================================================
-- Python Virtual Environment Detection
-- ============================================================================

local function find_python_venv()
  local cwd = vim.fn.getcwd()

  -- Check for .venv in current directory (uv default)
  local uv_venv = cwd .. '/.venv/bin/python'
  if vim.fn.filereadable(uv_venv) == 1 then
    return uv_venv
  end

  -- Check for virtualenv in current directory
  local venv = cwd .. '/venv/bin/python'
  if vim.fn.filereadable(venv) == 1 then
    return venv
  end

  -- Check VIRTUAL_ENV environment variable
  local virtual_env = os.getenv('VIRTUAL_ENV')
  if virtual_env then
    local venv_python = virtual_env .. '/bin/python'
    if vim.fn.filereadable(venv_python) == 1 then
      return venv_python
    end
  end

  -- Fallback to system Python
  return vim.fn.exepath('python3') or vim.fn.exepath('python')
end

-- Set Python host for Neovim
local python_path = find_python_venv()
vim.g.python3_host_prog = python_path

-- Command to show Python LSP info
vim.api.nvim_create_user_command('PyInfo', function()
  local python_path = find_python_venv()
  local virtual_env = os.getenv('VIRTUAL_ENV') or 'Not set'
  local cwd = vim.fn.getcwd()

  local info = string.format([[
Python LSP Info:
================
Python path: %s
VIRTUAL_ENV: %s
Current dir: %s
.venv exists: %s

]], python_path, virtual_env, cwd, vim.fn.isdirectory(cwd .. '/.venv') == 1 and 'yes' or 'no')

  -- Show LSP clients for current buffer
  local current_clients = vim.lsp.get_clients({ bufnr = 0 })
  info = info .. string.format('LSP Clients (current buffer %d):\n', vim.api.nvim_get_current_buf())
  for _, client in ipairs(current_clients) do
    info = info .. string.format('- %s (id: %d)\n', client.name, client.id)

    -- Show pyright settings
    if client.name == 'pyright' and client.config and client.config.settings then
      local py_settings = client.config.settings.python
      if py_settings then
        info = info .. string.format('  pythonPath: %s\n', py_settings.pythonPath or 'not set')
        info = info .. string.format('  root_dir: %s\n', client.config.root_dir or 'not set')
      end
    end
  end

  -- Show ALL Python LSP clients across all buffers
  local all_clients = vim.lsp.get_clients()
  local python_clients = {}
  for _, client in ipairs(all_clients) do
    if client.name == 'pyright' or client.name == 'ruff' then
      table.insert(python_clients, client)
    end
  end

  if #python_clients > 0 then
    info = info .. '\nALL Python LSP Clients (across all buffers):\n'
    for _, client in ipairs(python_clients) do
      local attached_bufs = {}
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.lsp.buf_is_attached(buf, client.id) then
          table.insert(attached_bufs, buf)
        end
      end
      info = info .. string.format('- %s (id: %d) attached to buffers: %s\n',
        client.name, client.id, table.concat(attached_bufs, ', '))
    end
  end

  -- Check if packages are importable
  info = info .. '\nTesting package resolution:\n'
  local handle = io.popen(python_path .. ' -c "import sys; print(sys.path)" 2>&1')
  if handle then
    local result = handle:read("*a")
    handle:close()
    -- Just show first few paths
    local paths = {}
    for path in result:gmatch("[^\n]+") do
      table.insert(paths, path)
      if #paths >= 3 then break end
    end
    info = info .. table.concat(paths, '\n') .. '\n'
  end

  print(info)
end, { desc = 'Show Python LSP info' })

-- Command to force clean Python LSP (stops all instances)
vim.api.nvim_create_user_command('PyCleanLsp', function()
  -- Stop ALL pyright and ruff clients across all buffers
  local all_clients = vim.lsp.get_clients()
  local stopped = {}
  for _, client in ipairs(all_clients) do
    if client.name == 'pyright' or client.name == 'ruff' then
      vim.lsp.stop_client(client.id, true)
      table.insert(stopped, string.format('%s (id: %d)', client.name, client.id))
    end
  end

  if #stopped > 0 then
    vim.notify('Stopped all Python LSP clients: ' .. table.concat(stopped, ', '), vim.log.levels.WARN)
  else
    vim.notify('No Python LSP clients were running', vim.log.levels.INFO)
  end
end, { desc = 'Stop all Python LSP clients' })

-- Command to reload Python LSP with updated venv
vim.api.nvim_create_user_command('PyReloadLsp', function()
  local new_python_path = find_python_venv()
  vim.g.python3_host_prog = new_python_path

  -- First, clean all existing clients
  vim.cmd('PyCleanLsp')

  -- Wait longer to ensure they're stopped, then restart
  vim.defer_fn(function()
    -- Reopen all Python buffers to trigger LSP attach
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == 'python' then
        local bufnr = vim.api.nvim_get_current_buf()
        vim.api.nvim_set_current_buf(buf)
        vim.cmd('edit')
        vim.api.nvim_set_current_buf(bufnr)
      end
    end
    vim.notify('Python LSP reloaded with: ' .. new_python_path, vim.log.levels.INFO)
  end, 1500)
end, { desc = 'Reload Python LSP with current venv' })

-- Command to manually update Pyright's Python path
vim.api.nvim_create_user_command('PyUpdatePath', function()
  local new_python_path = find_python_venv()
  local clients = vim.lsp.get_clients({ bufnr = 0, name = 'pyright' })

  for _, client in ipairs(clients) do
    client.config.settings.python.pythonPath = new_python_path
    client.notify('workspace/didChangeConfiguration', {
      settings = client.config.settings
    })
    vim.notify('Updated Pyright pythonPath to: ' .. new_python_path, vim.log.levels.INFO)
  end

  if #clients == 0 then
    vim.notify('No Pyright client found', vim.log.levels.WARN)
  end
end, { desc = 'Update Pyright Python path' })

-- ============================================================================
-- Pyright LSP - Type Checking and IntelliSense
-- ============================================================================

local ok, lspconfig = pcall(require, 'lspconfig')
if not ok then
  return
end

-- Check if LSP globals are set
if not _G.lsp_on_attach or not _G.lsp_capabilities then
  return
end

-- Setup pyright
lspconfig.pyright.setup({
  on_attach = _G.lsp_on_attach,
  capabilities = _G.lsp_capabilities,
  root_dir = function(fname)
    local util = require('lspconfig.util')
    return util.root_pattern('pyproject.toml', 'setup.py', '.venv', '.git')(fname)
      or util.find_git_ancestor(fname)
      or util.path.dirname(fname)
  end,
  settings = {
    python = {
      pythonPath = python_path,
      analysis = {
        typeCheckingMode = 'basic',
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'workspace',
        autoImportCompletions = true,
      }
    }
  },
  before_init = function(_, config)
    config.settings.python.pythonPath = find_python_venv()
  end,
})

-- ============================================================================
-- Ruff LSP - Fast Linting
-- ============================================================================

-- Setup ruff
lspconfig.ruff.setup({
  on_attach = function(client, bufnr)
    client.server_capabilities.hoverProvider = false
    _G.lsp_on_attach(client, bufnr)
  end,
  capabilities = _G.lsp_capabilities,
})

-- ============================================================================
-- Python Keybindings
-- ============================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Python-specific keybindings
autocmd('FileType', {
  group = augroup('PythonKeybindings', { clear = true }),
  pattern = 'python',
  callback = function()
    local opts = { buffer = true, noremap = true, silent = true }

    -- Show Python LSP info
    vim.keymap.set('n', '<leader>pi', ':PyInfo<CR>',
      vim.tbl_extend('force', opts, { desc = 'Show Python LSP info' }))

    -- Clean all Python LSP clients
    vim.keymap.set('n', '<leader>pc', ':PyCleanLsp<CR>',
      vim.tbl_extend('force', opts, { desc = 'Clean Python LSP clients' }))

    -- Reload LSP with current venv
    vim.keymap.set('n', '<leader>pr', ':PyReloadLsp<CR>',
      vim.tbl_extend('force', opts, { desc = 'Reload Python LSP' }))

    -- Run Python file with uv (reuses terminal)
    vim.keymap.set('n', '<leader>r', function()
      -- Close any existing terminal buffers first
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buftype == 'terminal' then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
      vim.cmd('split | term uv run %')
    end, vim.tbl_extend('force', opts, { desc = 'Run Python file (uv)' }))

    -- Run Python file with uv in vertical split (reuses terminal)
    vim.keymap.set('n', '<leader>R', function()
      -- Close any existing terminal buffers first
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buftype == 'terminal' then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
      vim.cmd('vsplit | term uv run %')
    end, vim.tbl_extend('force', opts, { desc = 'Run Python file (uv vsplit)' }))
  end,
})
