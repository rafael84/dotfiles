-- ============================================================================
-- Neovim Configuration Entry Point
-- ============================================================================
-- This is the main entry point for the Neovim configuration.
-- It loads all configuration modules in the correct order.

-- Load core configuration
require('config.options')      -- Vim options and settings
require('config.keymaps')      -- Base keymaps
require('config.autocmds')     -- Autocommands

-- Load plugin manager and plugins
require('plugins.init')        -- vim-plug setup and plugin list

-- Load plugin configurations
require('plugins.ui')          -- UI plugins (airline, colorscheme, etc)
require('plugins.editing')     -- Editing plugins (surround, commentary, etc)
require('plugins.navigation')  -- Navigation (telescope, nerdtree)
require('plugins.treesitter')  -- Treesitter syntax highlighting
require('plugins.completion')  -- nvim-cmp completion
require('plugins.lsp')         -- LSP base configuration
require('plugins.formatting')  -- Formatting (conform.nvim)
require('plugins.diagnostics') -- Diagnostics (trouble.nvim)
require('plugins.testing')     -- Testing (neotest)

-- Load language-specific configurations
require('plugins.languages.c')
require('plugins.languages.go')
require('plugins.languages.python')
require('plugins.languages.javascript')
require('plugins.languages.clojure')

-- Load theme (must be after plugins are loaded)
vim.cmd('colorscheme PaperColor')
