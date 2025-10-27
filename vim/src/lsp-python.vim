"------------------------------------------------------------------------------
" Python LSP Configuration with uv support
"------------------------------------------------------------------------------

lua << EOF
-- Function to detect uv virtual environment
local function find_uv_venv()
  local cwd = vim.fn.getcwd()

  -- Check for .venv in current directory (uv default)
  local uv_venv = cwd .. '/.venv'
  if vim.fn.isdirectory(uv_venv) == 1 then
    return uv_venv .. '/bin/python'
  end

  -- Check for virtualenv in current directory
  local venv = cwd .. '/venv'
  if vim.fn.isdirectory(venv) == 1 then
    return venv .. '/bin/python'
  end

  -- Check VIRTUAL_ENV environment variable
  local virtual_env = os.getenv('VIRTUAL_ENV')
  if virtual_env then
    return virtual_env .. '/bin/python'
  end

  -- Fallback to system Python
  return vim.fn.exepath('python3') or vim.fn.exepath('python')
end

-- Set Python host for Neovim
local python_path = find_uv_venv()
vim.g.python3_host_prog = python_path

-- Configure Pyright LSP
require('lspconfig').pyright.setup({
  on_attach = _G.lsp_on_attach,
  capabilities = _G.lsp_capabilities,
  settings = {
    python = {
      pythonPath = python_path,
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      }
    }
  },
  before_init = function(_, config)
    -- Update pythonPath on each LSP start (in case venv changes)
    config.settings.python.pythonPath = find_uv_venv()
  end,
})

-- Configure Ruff LSP (fast linting)
require('lspconfig').ruff.setup({
  on_attach = function(client, bufnr)
    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
    _G.lsp_on_attach(client, bufnr)
  end,
  capabilities = _G.lsp_capabilities,
})
EOF
