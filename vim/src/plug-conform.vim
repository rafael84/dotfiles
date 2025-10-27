"------------------------------------------------------------------------------
" conform.nvim - Formatting
"------------------------------------------------------------------------------

lua << EOF
require("conform").setup({
  formatters_by_ft = {
    -- Python
    python = function(bufnr)
      -- Prefer ruff format over black (faster and handles imports)
      return { "ruff_format", "ruff_organize_imports" }
    end,

    -- JavaScript/TypeScript
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },

    -- Web
    html = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },

    -- Shell
    sh = { "shfmt" },
    bash = { "shfmt" },
    zsh = { "shfmt" },

    -- Go (gopls handles formatting via LSP, but these are fallbacks)
    go = { "gofumpt", "goimports" },

    -- Lua
    lua = { "stylua" },
  },

  -- Format on save
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },

  formatters = {
    shfmt = {
      prepend_args = { "-i", "2", "-ci" },  -- 2 spaces, indent switch cases
    },
    ruff_format = {
      command = "ruff",
      args = { "format", "--stdin-filename", "$FILENAME", "-" },
    },
    ruff_organize_imports = {
      command = "ruff",
      args = { "check", "--select", "I", "--fix", "--stdin-filename", "$FILENAME", "-" },
    },
  },
})

-- Command to format current buffer
vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_fallback = true, range = range })
end, { range = true })
EOF

" Keybinding for manual format
nnoremap <silent> <leader>fm :Format<CR>
vnoremap <silent> <leader>fm :Format<CR>
