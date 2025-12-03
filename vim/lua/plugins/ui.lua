-- ============================================================================
-- UI Plugins Configuration
-- ============================================================================

-- ============================================================================
-- vim-airline - Statusline
-- ============================================================================

-- Disable powerline fonts and use ASCII mode
vim.g.airline_powerline_fonts = 0
vim.g.airline_symbols_ascii = 1
vim.g.airline_statusline_ontop = 0
vim.g['airline#extensions#coc#enabled'] = 1
vim.g['airline#extensions#tabline#enabled'] = 1

-- Python virtualenv indicator
vim.cmd([[
  function! VirtualEnvStatusline()
    if &filetype ==# 'python'
      let l:venv = $VIRTUAL_ENV
      if !empty(l:venv)
        return ' [' . fnamemodify(l:venv, ':t') . ']'
      endif
      " Check for .venv in current directory
      let l:cwd_venv = getcwd() . '/.venv'
      if isdirectory(l:cwd_venv)
        return ' [.venv]'
      endif
    endif
    return ''
  endfunction

  " Add to airline section
  let g:airline_section_x = '%{VirtualEnvStatusline()} %{&filetype}'
]])


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
