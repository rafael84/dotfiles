-- ============================================================================
-- Go Language Configuration
-- ============================================================================

-- ============================================================================
-- gopls - Go Language Server
-- ============================================================================

local ok, lspconfig = pcall(require, 'lspconfig')
if not ok then
  return
end

-- Check if LSP globals are set
if not _G.lsp_on_attach or not _G.lsp_capabilities then
  return
end

-- Safely setup gopls (fails gracefully if gopls is not installed)
if vim.fn.executable('gopls') == 0 then
  return
end

-- Suppress error output during setup attempt
local old_notify = vim.notify
vim.notify = function() end

local setup_ok, err = pcall(function()
  lspconfig['gopls'].setup({
    on_attach = _G.lsp_on_attach,
    capabilities = _G.lsp_capabilities,
    settings = {
      gopls = {
        -- Analysis settings
        analyses = {
          unusedparams = true,
          shadow = true,
          nilness = true,
          unusedwrite = true,
          useany = true,
        },

        -- Static check analyzers
        staticcheck = true,

        -- Code lens
        codelenses = {
          gc_details = true,
          generate = true,
          regenerate_cgo = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
        },

        -- Hints
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },

        -- Formatting
        gofumpt = true, -- Stricter gofmt

        -- Organize imports
        ['local'] = '', -- Set to your module path for local imports

        -- Completion
        usePlaceholders = true,
        completeUnimported = true,

        -- Experimental features
        experimentalPostfixCompletions = true,
      },
    },

    -- File types
    filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },

    -- Root directory detection
    root_dir = lspconfig.util.root_pattern('go.work', 'go.mod', '.git'),
  })
end)

-- Restore notify
vim.notify = old_notify

if not setup_ok then
  return
end

-- ============================================================================
-- vim-go - Go tooling
-- ============================================================================
-- Note: LSP features (go-to-def, autocomplete, hover) are handled by gopls
-- vim-go provides Go-specific commands: :GoBuild, :GoTest, :GoRun, etc.

-- Disable LSP features (handled by gopls)
vim.g.go_def_mapping_enabled = 0       -- Use LSP for gd
vim.g.go_code_completion_enabled = 0   -- Use nvim-cmp with gopls
vim.g.go_gopls_enabled = 0             -- We configure gopls directly
vim.g.go_doc_keywordprg_enabled = 0    -- Use LSP for K

-- Disable formatting (handled by gopls via LSP)
vim.g.go_fmt_autosave = 0              -- LSP handles format on save
vim.g.go_imports_autosave = 0          -- LSP handles organize imports

-- Keep syntax highlighting (though Treesitter is better)
vim.g.go_highlight_build_constraints = 1
vim.g.go_highlight_functions = 1
vim.g.go_highlight_function_calls = 1
vim.g.go_highlight_methods = 1
vim.g.go_highlight_structs = 1
vim.g.go_highlight_operators = 1
vim.g.go_highlight_types = 1
vim.g.go_highlight_fields = 1
vim.g.go_highlight_variable_declarations = 1
vim.g.go_highlight_variable_assignments = 1

-- Other settings
vim.g.go_echo_command_info = 1
vim.g.go_list_type = 'quickfix'
vim.g.go_modifytags_transform = 'camelcase'
vim.g.go_autodetect_gopath = 1

-- ============================================================================
-- Go Autocommands and Keybindings
-- ============================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Format and organize imports on save
autocmd('BufWritePre', {
  group = augroup('GoFormat', { clear = true }),
  pattern = '*.go',
  callback = function()
    vim.lsp.buf.format({ async = false })
    vim.lsp.buf.code_action({
      context = { only = { 'source.organizeImports' } },
      apply = true
    })
  end,
})

-- Go-specific keybindings
autocmd('FileType', {
  group = augroup('GoKeybindings', { clear = true }),
  pattern = 'go',
  callback = function()
    local opts = { buffer = true, noremap = true, silent = true }

    -- Build helper function
    local function build_go_files()
      local file = vim.fn.expand('%')
      if file:match('_test%.go$') then
        vim.cmd('GoTestCompile')
      elseif file:match('%.go$') then
        vim.cmd('GoBuild')
      end
    end

    -- Keymaps are defined in config/keymaps.lua
  end,
})

-- Register Go-specific keybindings with which-key
local status_ok, wk = pcall(require, 'which-key')
if not status_ok then
  return
end

wk.add({
  { '<leader>g', group = 'Go', mode = 'n', cond = function() return vim.bo.filetype == 'go' end },
  { '<leader>gt', desc = 'Go to type definition', cond = function() return vim.bo.filetype == 'go' end },
  { '<leader>gi', desc = 'Go to implementation', cond = function() return vim.bo.filetype == 'go' end },
  { '<leader>gc', desc = 'Go callees', cond = function() return vim.bo.filetype == 'go' end },
  { '<leader>gC', desc = 'Go callers', cond = function() return vim.bo.filetype == 'go' end },
  { '<leader>gd', desc = 'Go describe', cond = function() return vim.bo.filetype == 'go' end },
  { '<leader>ge', desc = 'Go if err', cond = function() return vim.bo.filetype == 'go' end },
  { '<leader>gf', desc = 'Go fill struct', cond = function() return vim.bo.filetype == 'go' end },
  { '<leader>a', desc = 'Alternate file', cond = function() return vim.bo.filetype == 'go' end },
  { '<leader>b', desc = 'Build', cond = function() return vim.bo.filetype == 'go' end },
  { '<leader>r', desc = 'Run', cond = function() return vim.bo.filetype == 'go' end },
})
