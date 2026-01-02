-- ============================================================================
-- Editing Plugins Configuration
-- ============================================================================
-- Keymaps are defined in config/keymaps.lua

-- vim-move: disable default mappings
vim.g.move_map_keys = 0

-- vim-easy-align: custom delimiters
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

-- vim-sexp: structural editing for S-expressions and function calls
vim.g.sexp_filetypes = 'clojure,scheme,lisp,fennel,c,cpp,javascript,typescript,python,go,rust'

-- Disable default mappings (custom mappings in config/keymaps.lua)
vim.g.sexp_mappings = {
  sexp_raise_element = '',
  sexp_splice_list = '',
  sexp_insert_at_list_head = '',
  sexp_insert_at_list_tail = '',
  sexp_round_head_wrap_element = '',
  sexp_square_head_wrap_element = '',
  sexp_curly_head_wrap_element = '',
  sexp_swap_element_forward = '',
  sexp_swap_element_backward = '',
  sexp_emit_tail_element = '',
  sexp_capture_next_element = '',
}
