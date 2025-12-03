-- ============================================================================
-- UI Plugins Configuration
-- ============================================================================

-- ============================================================================
-- vim-airline - Statusline
-- ============================================================================

vim.g.airline_statusline_ontop = 0
vim.g['airline#extensions#coc#enabled'] = 1
vim.g['airline#extensions#tabline#enabled'] = 1

-- ============================================================================
-- rainbow - Rainbow Parentheses (for Clojure)
-- ============================================================================

vim.g.rainbow_active = 1
vim.g.rainbow_conf = {
  guifgs = { 'royalblue3', 'darkorange3', 'seagreen3', 'firebrick' },
  ctermfgs = { 'lightblue', 'lightyellow', 'lightcyan', 'lightmagenta' },
  parentheses = {
    'start=/(/ end=/)/ fold',
    'start=/\\[/ end=/\\]/ fold',
    'start=/{/ end=/}/ fold'
  },
  separately = {
    ['*'] = 0,
    clojure = {}
  }
}

-- ============================================================================
-- vim-json - JSON syntax
-- ============================================================================

vim.g.vim_json_syntax_conceal = 0

-- ============================================================================
-- GitGutter - Git diff in gutter
-- ============================================================================

-- GitGutter uses default settings, no custom configuration needed
