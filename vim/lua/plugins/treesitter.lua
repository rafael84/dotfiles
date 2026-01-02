-- ============================================================================
-- Treesitter Configuration
-- ============================================================================

-- Protect against errors if treesitter is not installed yet
local status_ok, treesitter = pcall(require, 'nvim-treesitter')
if not status_ok then
  return
end

treesitter.setup({
  -- Languages to install
  ensure_installed = {
    'c',
    'cpp',
    'python',
    'javascript',
    'typescript',
    'tsx',
    'bash',
    'lua',
    'vim',
    'vimdoc',
    'html',
    'css',
    'json',
    'yaml',
    'toml',
    'markdown',
    'markdown_inline',
    'go',
    'clojure',
    'dockerfile',
    'git_config',
    'git_rebase',
    'gitattributes',
    'gitcommit',
    'gitignore',
  },

  -- Install parsers synchronously
  sync_install = false,

  -- Automatically install missing parsers
  auto_install = true,

  -- Syntax highlighting
  highlight = {
    enable = true,

    -- Disable for very large files
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,

    additional_vim_regex_highlighting = false,
  },

  -- Indentation
  indent = {
    enable = true,
  },

  -- Incremental selection
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = '<CR>',
      scope_incremental = '<S-CR>',
      node_decremental = '<BS>',
    },
  },

  -- Enable folding
  fold = {
    enable = true,
  },
})
