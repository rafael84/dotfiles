-- ============================================================================
-- Editing Plugins Configuration
-- ============================================================================

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ============================================================================
-- vim-move - Move lines/blocks
-- ============================================================================

vim.g.move_map_keys = 0

map('v', '<C-k>', '<Plug>MoveBlockUp', { silent = true })
map('v', '<C-j>', '<Plug>MoveBlockDown', { silent = true })
map('n', 'mj', '<Plug>MoveLineDown', { silent = true })
map('n', 'mk', '<Plug>MoveLineUp', { silent = true })

-- ============================================================================
-- sideways.vim - Move function arguments
-- ============================================================================

map('n', '<Leader>sr', ':SidewaysRight<cr>', opts)
map('n', '<Leader>sl', ':SidewaysLeft<cr>', opts)

-- ============================================================================
-- splitjoin.vim - Split/join code blocks
-- ============================================================================

vim.g.splitjoin_split_mapping = ''
vim.g.splitjoin_join_mapping = ''

map('n', '<Leader>j', ':SplitjoinSplit<cr>', opts)
map('n', '<Leader>k', ':SplitjoinJoin<cr>', opts)

-- ============================================================================
-- vim-easy-align - Alignment
-- ============================================================================

-- Start interactive EasyAlign in visual mode
map('v', '<Enter>', '<Plug>(EasyAlign)', { silent = true })

-- Start interactive EasyAlign in visual mode (e.g. vipga)
map('x', 'ga', '<Plug>(EasyAlign)', { silent = true })

-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
map('n', 'ga', '<Plug>(EasyAlign)', { silent = true })

vim.g.easy_align_delimiters = {
  ['['] = {
    pattern = '[\\[]',
    left_margin = 1,
    right_margin = 0,
    stick_to_left = 0
  },
  ['('] = {
    pattern = '[\\(]',
    left_margin = 1,
    right_margin = 0,
    stick_to_left = 0
  }
}

-- ============================================================================
-- vim-sexp - S-expression editing (for Clojure)
-- ============================================================================

map('n', 'ii', '>I<CR>', opts)
