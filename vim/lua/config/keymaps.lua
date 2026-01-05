-- ============================================================================
-- ALL KEYMAPS - Single Source of Truth
-- ============================================================================
-- All keymaps are defined here in one place for easy management.
-- Language-specific keymaps are wrapped in autocommands for their filetypes.
-- Complex function logic is extracted to appropriate modules.

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ============================================================================
-- General
-- ============================================================================

map('n', ';', ':', { noremap = true })
map('i', 'jj', '<Esc>', opts)
map('n', 'JJJJ', '<nop>', opts)

-- ============================================================================
-- Saving
-- ============================================================================

map('n', '<Leader>w', ':w<CR>', opts)
map('v', '<Leader>w', '<ESC><ESC>:w<CR>', opts)

-- ============================================================================
-- Movement
-- ============================================================================

map('n', 'j', 'gj', opts)
map('n', 'k', 'gk', opts)
map('n', '<C-j>', '<C-W>j', opts)
map('n', '<C-k>', '<C-W>k', opts)
map('n', '<C-h>', '<C-W>h', opts)
map('n', '<C-l>', '<C-W>l', opts)
map('n', '<C-d>', '<C-d>zz', opts)
map('n', '<C-u>', '<C-u>zz', opts)
map('n', 'n', 'nzzzv', opts)
map('n', 'N', 'Nzzzv', opts)

-- ============================================================================
-- Editing
-- ============================================================================

map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)
map('v', '<Tab>', '>gv', opts)
map('v', '<S-Tab>', '<gv', opts)
map('v', '<Space>', '<Esc>gV', opts)
map('v', '<C-p>', "y'>p", opts)
map('n', '<M-j>', 'mz:m+<cr>`z', opts)
map('n', '<M-k>', 'mz:m-2<cr>`z', opts)
map('v', '<M-j>', ":m'>+<cr>`<my`>mzgv`yo`z", opts)
map('v', '<M-k>', ":m'<-2<cr>`>my`<mzgv`yo`z", opts)

if vim.fn.has('mac') == 1 or vim.fn.has('macunix') == 1 then
  map('n', '<D-j>', '<M-j>', opts)
  map('n', '<D-k>', '<M-k>', opts)
  map('v', '<D-j>', '<M-j>', opts)
  map('v', '<D-k>', '<M-k>', opts)
end

-- vim-move plugin
map('v', '<C-k>', '<Plug>MoveBlockUp', { silent = true })
map('v', '<C-j>', '<Plug>MoveBlockDown', { silent = true })
map('n', 'mj', '<Plug>MoveLineDown', { silent = true })
map('n', 'mk', '<Plug>MoveLineUp', { silent = true })

-- vim-sideways plugin
map('n', '<Leader>sr', ':SidewaysRight<cr>', opts)
map('n', '<Leader>sl', ':SidewaysLeft<cr>', opts)

-- EasyAlign plugin
map('v', '<Enter>', '<Plug>(EasyAlign)', { silent = true })
map('x', 'ga', '<Plug>(EasyAlign)', { silent = true })
map('n', 'ga', '<Plug>(EasyAlign)', { silent = true })

-- vim-sexp plugin (structural editing)
map('n', '<leader>kr', '<Plug>(sexp_raise_element)', { silent = true, desc = 'Raise: replace parent with current element' })
map('n', '<leader>ko', '<Plug>(sexp_splice_list)', { silent = true, desc = 'Splice: remove parent, keep children' })
map('n', '<leader>kI', '<Plug>(sexp_insert_at_list_head)', { silent = true, desc = 'Insert at start of form' })
map('n', '<leader>kA', '<Plug>(sexp_insert_at_list_tail)', { silent = true, desc = 'Insert at end of form' })
map('n', '<leader>kw', '<Plug>(sexp_round_head_wrap_element)', { silent = true, desc = 'Wrap in parentheses' })
map('n', '<leader>k[', '<Plug>(sexp_square_head_wrap_element)', { silent = true, desc = 'Wrap in square brackets' })
map('n', '<leader>k{', '<Plug>(sexp_curly_head_wrap_element)', { silent = true, desc = 'Wrap in curly braces' })
map('n', '<leader>kj', '<Plug>(sexp_swap_element_forward)', { silent = true, desc = 'Swap element forward' })
map('n', '<leader>kk', '<Plug>(sexp_swap_element_backward)', { silent = true, desc = 'Swap element backward' })
map('n', '<leader>kl', '<Plug>(sexp_emit_tail_element)', { silent = true, desc = 'Slurp: move element in' })
map('n', '<leader>kh', '<Plug>(sexp_capture_next_element)', { silent = true, desc = 'Barf: move element out' })

map('n', 'ii', '>I<CR>', opts)

-- ============================================================================
-- Search
-- ============================================================================

map('n', '<Leader>/', ':nohlsearch<CR>', opts)

-- ============================================================================
-- Replace
-- ============================================================================

-- Replace word under cursor (interactive)
map('n', '<Leader>R', ':%s/\\<<C-r><C-w>\\>/', { noremap = true, silent = false })

-- Replace visual selection (interactive)
map('v', '<Leader>R', '"hy:%s/<C-r>h/', { noremap = true, silent = false })

-- ============================================================================
-- Navigation - NERDTree
-- ============================================================================

map('n', '<F2>', ':NERDTreeToggle<CR>', opts)
map('n', 'LF', ':NERDTreeFind<CR>', opts)

-- ============================================================================
-- Navigation - Tagbar
-- ============================================================================

map('n', '<F3>', ':TagbarToggle<CR>', opts)

-- ============================================================================
-- Navigation - Telescope
-- ============================================================================

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
-- Navigation - Ripgrep
-- ============================================================================

map('n', 'g*', ':Rg <CR>', opts)
map('v', 'g*', ':call RgVisual() <CR>', opts)

-- Search word under cursor with Rg
map('n', '<leader>*', function()
  require('config.utils').ripgrep_current_word()
end, opts)

-- Search visual selection with Rg
map('v', '<leader>*', function()
  require('config.utils').ripgrep_visual_selection()
end, opts)

-- ============================================================================
-- Navigation - GitHub
-- ============================================================================

map('n', '<leader>gh', ':GBrowse<CR>', opts)
map('v', '<leader>gh', ':GBrowse<CR>', opts)

-- ============================================================================
-- Spec Viewer
-- ============================================================================

map('n', '<leader>so', ':SpecOpen ', { noremap = true, silent = false, desc = 'Open spec file (prompt for path)' })
map('n', '<leader>sO', function() require('plugins.spec-viewer').open() end, { desc = 'Open current file in spec window' })
map('n', '<leader>st', function() require('plugins.spec-viewer').toggle() end, { desc = 'Toggle spec window' })
map('n', '<leader>sr', function() require('plugins.spec-viewer').reload() end, { desc = 'Reload spec file' })
map('n', '<leader>sf', function() require('plugins.spec-viewer').focus() end, { desc = 'Focus spec window' })
map('n', '<leader>sc', function() require('plugins.spec-viewer').close() end, { desc = 'Close spec window' })

-- ============================================================================
-- Quickfix / Compilation Errors
-- ============================================================================

map('n', '[q', ':cprev<CR>', opts)
map('n', ']q', ':cnext<CR>', opts)
map('n', '[Q', ':cfirst<CR>', opts)
map('n', ']Q', ':clast<CR>', opts)
map('n', '<leader>qo', ':copen<CR>', opts)
map('n', '<leader>qc', ':cclose<CR>', opts)

-- Quickfix window navigation (buffer-local to override global mappings)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    local buf_opts = { buffer = true, noremap = true, silent = true }
    vim.keymap.set('n', '<C-n>', 'j', buf_opts)  -- Just move down in the list
    vim.keymap.set('n', '<C-p>', 'k', buf_opts)  -- Just move up in the list
    vim.keymap.set('n', '<CR>', '<CR>', buf_opts)  -- Keep Enter to jump to file
  end,
})

-- Man page navigation (buffer-local)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'man',
  callback = function()
    local buf_opts = { buffer = true, noremap = true, silent = true }
    vim.keymap.set('n', '<C-i>', '<C-]>', buf_opts)  -- Jump to tag/link under cursor
  end,
})

-- ============================================================================
-- Diagnostics - Trouble
-- ============================================================================

map('n', '<leader>xx', ':Trouble diagnostics toggle<CR>', opts)
map('n', '<leader>xw', ':Trouble diagnostics toggle filter.buf=0<CR>', opts)
map('n', '<leader>xq', ':Trouble quickfix toggle<CR>', opts)
map('n', '<leader>xl', ':Trouble loclist toggle<CR>', opts)
map('n', '<leader>xr', ':Trouble lsp_references toggle<CR>', opts)
map('n', '<leader>xQ', function()
  vim.fn.setqflist({})
  vim.cmd('cclose')
end, opts)
map('n', '<leader>xW', function()
  vim.fn.setloclist(0, {})
  vim.cmd('lclose')
end, opts)

-- ============================================================================
-- LSP
-- ============================================================================

-- These are set up by on_attach function in plugins/lsp.lua
-- Listed here for reference, actual setup in lsp.lua:
-- gd, gD, gi, gr, gtd - navigation
-- K - hover, <leader>K - hover in split, <leader>sh - signature help
-- <leader>rn - rename, <leader>ca - code action
-- <leader>f - format, [d/]d - diagnostics
-- <leader>e - show diagnostic, <leader>q - diagnostic loclist

-- ============================================================================
-- Formatting
-- ============================================================================

map('n', '<leader>fm', ':Format<CR>', opts)
map('v', '<leader>fm', ':Format<CR>', opts)

-- ============================================================================
-- Misc
-- ============================================================================

map('n', '<Leader>m', 'mmHmt:%s/<C-V><cr>//ge<cr>\'tzt\'m', opts)
map('n', 'q:', ':q', opts)
map('n', 'Zz', '<c-w>_ | <c-w>|', opts)
map('n', 'Zo', '<c-w>=', opts)

-- Open :messages in a buffer
vim.api.nvim_create_user_command('Messages', function()
  require('config.utils').open_messages()
end, {})

map('n', '<Leader>M', ':Messages<CR>', opts)

-- Reload config
vim.api.nvim_create_user_command('ReloadConfig', function()
  require('config.utils').reload_config()
end, {})

map('n', '<Leader>cr', ':ReloadConfig<CR>', opts)

-- ============================================================================
-- Language-Specific Keymaps (filetype-scoped)
-- ============================================================================

-- C
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'c',
  callback = function()
    local buf_opts = { buffer = true, noremap = true, silent = true }
    local c = require('plugins.languages.c')

    vim.keymap.set('n', '<Leader>a', ':ClangdSwitchSourceHeader<CR>', buf_opts)
    vim.keymap.set('n', '<leader>cF', ':CGenClangFormat<CR>', buf_opts)
    vim.keymap.set('n', '<leader>cf', ':CGenCompileFlags raylib<CR>', buf_opts)

    -- Select build target (interactive)
    vim.keymap.set('n', '<leader>bs', function()
      c.select_build_target()
    end, buf_opts)

    -- Select binary to run (interactive)
    vim.keymap.set('n', '<leader>rs', function()
      c.select_binary_path()
    end, buf_opts)

    -- Build only (uses quickfix for errors)
    vim.keymap.set('n', '<leader>b', function()
      c.build()
    end, buf_opts)

    -- Build and run (uses quickfix for build errors)
    vim.keymap.set('n', '<leader>r', function()
      c.build_and_run()
    end, buf_opts)
  end
})

-- Go
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function()
    local buf_opts = { buffer = true, noremap = true, silent = true }
    vim.keymap.set('n', '<Leader>a', '<Plug>(go-alternate-edit)', buf_opts)
    vim.keymap.set('n', '<Leader>c', '<Plug>(go-coverage-toggle)', buf_opts)
    vim.keymap.set('n', '<leader>b', function()
      local is_gofile = vim.fn.expand('%:e') == 'go'
      if is_gofile then
        vim.cmd('write')
        vim.cmd('GoBuild')
      end
    end, buf_opts)
    vim.keymap.set('n', '<leader>r', '<Plug>(go-run)', buf_opts)
    vim.keymap.set('n', '<leader>t', '<Plug>(go-test)', buf_opts)
    vim.keymap.set('n', '<leader>tf', '<Plug>(go-test-func)', buf_opts)
    vim.keymap.set('n', '<leader>gc', '<Plug>(go-callees)', buf_opts)
    vim.keymap.set('n', '<leader>gC', '<Plug>(go-callers)', buf_opts)
    vim.keymap.set('n', '<leader>gd', '<Plug>(go-describe)', buf_opts)
    vim.keymap.set('n', '<leader>ge', '<Plug>(go-iferr)', buf_opts)
    vim.keymap.set('n', '<leader>gf', '<Plug>(go-fill-struct)', buf_opts)
    vim.keymap.set('n', '<leader>gt', vim.lsp.buf.type_definition, buf_opts)
    vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, buf_opts)
    vim.keymap.set('n', '<leader>gs', vim.lsp.buf.signature_help, buf_opts)
  end
})

-- Python
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    local buf_opts = { buffer = true, noremap = true, silent = true }
    vim.keymap.set('n', '<leader>pi', ':PyInfo<CR>', buf_opts)
    vim.keymap.set('n', '<leader>pc', ':PyCleanLsp<CR>', buf_opts)
    vim.keymap.set('n', '<leader>pr', ':PyReloadLsp<CR>', buf_opts)
    vim.keymap.set('n', '<leader>r', function()
      vim.cmd('write')
      local file = vim.fn.expand('%')
      vim.cmd('!python3 ' .. file)
    end, buf_opts)
    vim.keymap.set('n', '<leader>R', function()
      vim.cmd('write')
      local file = vim.fn.expand('%')
      vim.cmd('!python3 -m pdb ' .. file)
    end, buf_opts)
  end
})

-- Clojure
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'clojure',
  callback = function()
    local buf_opts = { buffer = true, noremap = true, silent = true }
    vim.keymap.set('n', 'rr', ':Require<cr>', buf_opts)
    vim.keymap.set('n', 'ee', ':Eval<cr>', buf_opts)
    vim.keymap.set('n', 'gd', '<Plug>FireplaceDjump', { buffer = true })
  end
})

-- Markdown
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    local buf_opts = { buffer = true, noremap = true, silent = true }
    vim.keymap.set('n', '<leader>ms', '<Plug>MarkdownPreview', buf_opts)
    vim.keymap.set('n', '<leader>mS', '<Plug>MarkdownPreviewStop', buf_opts)
    vim.keymap.set('n', '<leader>mp', '<Plug>MarkdownPreviewToggle', buf_opts)
  end
})
