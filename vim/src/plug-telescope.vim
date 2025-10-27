"------------------------------------------------------------------------------
" Telescope - Fuzzy Finder
"------------------------------------------------------------------------------

lua << EOF
local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<Esc>"] = actions.close,
      },
    },
    prompt_prefix = "🔍 ",
    selection_caret = "➜ ",
    path_display = { "truncate" },
    file_ignore_patterns = {
      "node_modules",
      ".git/",
      "dist/",
      "build/",
      "target/",
      "*.pyc",
      "__pycache__/",
      ".venv/",
      "venv/",
    },
  },
  pickers = {
    find_files = {
      hidden = true,
      find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})

-- Load extensions
telescope.load_extension('fzf')
EOF

" Telescope keybindings
nnoremap <C-p> :Telescope find_files<CR>
nnoremap <leader>ff :Telescope find_files<CR>
nnoremap <leader>fg :Telescope live_grep<CR>
nnoremap <leader>fb :Telescope buffers<CR>
nnoremap <leader>fh :Telescope help_tags<CR>
nnoremap <leader>fr :Telescope oldfiles<CR>
nnoremap <leader>fc :Telescope commands<CR>
nnoremap <leader>fs :Telescope lsp_document_symbols<CR>
nnoremap <leader>fw :Telescope lsp_workspace_symbols<CR>
nnoremap <leader>fd :Telescope diagnostics<CR>
