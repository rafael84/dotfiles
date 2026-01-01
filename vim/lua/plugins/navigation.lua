-- ============================================================================
-- Navigation Plugins Configuration
-- ============================================================================

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

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

-- Keybindings
map('n', '<F2>', ':NERDTreeToggle<CR>', opts)
map('n', 'LF', ':NERDTreeFind<CR>', opts)

-- ============================================================================
-- Tagbar - Code Outline
-- ============================================================================

map('n', '<F3>', ':TagbarToggle<CR>', opts)

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
    -- Fix for Neovim 0.11+ treesitter API changes
    buffer_previewer_maker = function(filepath, bufnr, opts)
      opts = opts or {}

      -- Simple file preview without treesitter highlighting to avoid ft_to_lang error
      vim.loop.fs_stat(filepath, function(_, stat)
        if not stat then return end
        if stat.size > 100000 then
          -- File is too large, show message
          vim.schedule(function()
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { 'File too large for preview' })
          end)
        else
          -- Read and display file
          vim.schedule(function()
            local ok = pcall(vim.fn.readfile, filepath)
            if ok then
              vim.api.nvim_buf_call(bufnr, function()
                vim.cmd('silent! edit ' .. vim.fn.fnameescape(filepath))
              end)
            end
          end)
        end
      end)
    end,
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

-- Keybindings
map('n', '<C-p>', ':Telescope find_files<CR>', opts)
map('n', '<leader>ff', ':Telescope find_files<CR>', opts)
map('n', '<leader>fg', ':Telescope live_grep<CR>', opts)
map('n', '<leader>fb', ':Telescope buffers<CR>', opts)
map('n', '<leader>fh', ':Telescope help_tags<CR>', opts)
map('n', '<leader>fr', ':Telescope oldfiles<CR>', opts)
map('n', '<leader>fc', ':Telescope commands<CR>', opts)
map('n', '<leader>fs', ':Telescope lsp_document_symbols<CR>', opts)
map('n', '<leader>fw', ':Telescope lsp_workspace_symbols<CR>', opts)
map('n', '<leader>fd', ':Telescope diagnostics<CR>', opts)

-- ============================================================================
-- vim-ripgrep - Search with ripgrep
-- ============================================================================

vim.g.rg_highlight = 1
vim.g.rg_derive_root = 1

map('n', 'g*', ':Rg <CR>', opts)
map('v', 'g*', ':call RgVisual() <CR>', opts)

-- ============================================================================
-- vim-fugitive - Open file on GitHub
-- ============================================================================

-- Open current file on GitHub (with current line highlighted)
-- Uses vim-fugitive's :GBrowse command
map('n', '<leader>gh', ':GBrowse<CR>', opts)
-- Open current file on GitHub (with selected lines highlighted in visual mode)
map('v', '<leader>gh', ':GBrowse<CR>', opts)
