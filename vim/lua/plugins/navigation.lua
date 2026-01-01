-- ============================================================================
-- Navigation Plugins Configuration
-- ============================================================================
-- Keymaps are defined in config/keymaps.lua

-- ============================================================================
-- NERDTree - File Explorer
-- ============================================================================

vim.g.NERDTreeChDirMode = 2
vim.g.NERDTreeIgnore = { '\\.rbc$', '\\~$', '\\.pyc$', '\\.db$', '\\.sqlite$', '__pycache__' }
vim.g.NERDTreeMapOpenInTabSilent = '<RightMouse>'
vim.g.NERDTreeShowBookmarks = 1
vim.g.NERDTreeSortOrder = { '^__\\.py$', '\\/$', '*', '\\.swp$', '\\.bak$', '\\~$' }
vim.g.NERDTreeWinSize = 31
vim.g.nerdtree_tabs_focus_on_files = 1

-- Open NERDTree on startup when no file specified
vim.api.nvim_create_autocmd('VimEnter', {
  pattern = '*',
  callback = function()
    if vim.fn.argc() == 0 then
      vim.cmd('NERDTree')
    end
  end,
})

-- ============================================================================
-- Tagbar - Code Outline
-- ============================================================================

-- Go tag configuration
vim.g.tagbar_type_go = {
  ctagstype = 'go',
  kinds = {
    'p:package',
    'i:imports:1',
    'c:constants',
    'v:variables',
    't:types',
    'n:interfaces',
    'w:fields',
    'e:embedded',
    'm:methods',
    'r:constructor',
    'f:functions'
  },
  sro = '.',
  kind2scope = {
    t = 'ctype',
    n = 'ntype'
  },
  scope2kind = {
    ctype = 't',
    ntype = 'n'
  },
  ctagsbin = 'gotags',
  ctagsargs = '-sort -silent'
}

-- ============================================================================
-- Telescope - Fuzzy Finder
-- ============================================================================

local status_ok, telescope = pcall(require, 'telescope')
if not status_ok then
  return
end

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ['<C-j>'] = function(...) return require('telescope.actions').move_selection_next(...) end,
        ['<C-k>'] = function(...) return require('telescope.actions').move_selection_previous(...) end,
        ['<C-q>'] = function(...)
          local actions = require('telescope.actions')
          return (actions.send_to_qflist + actions.open_qflist)(...)
        end,
        ['<Esc>'] = function(...) return require('telescope.actions').close(...) end,
      },
    },
    prompt_prefix = '🔍 ',
    selection_caret = '➜ ',
    path_display = { 'truncate' },
    file_ignore_patterns = {
      'node_modules',
      '.git/',
      'dist/',
      'build/',
      'target/',
      '*.pyc',
      '__pycache__/',
      '.venv/',
      'venv/',
    },
  },
  pickers = {
    find_files = {
      hidden = true,
      find_command = { 'rg', '--files', '--hidden', '--glob', '!.git/*' },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
  },
})

-- Load extensions
pcall(telescope.load_extension, 'fzf')

-- ============================================================================
-- vim-ripgrep - Search with ripgrep
-- ============================================================================

vim.g.rg_highlight = 1
vim.g.rg_derive_root = 1
