"------------------------------------------------------------------------------
" nvim-lint - Additional Linting
"------------------------------------------------------------------------------

lua << EOF
require('lint').linters_by_ft = {
  -- Python - use ruff via LSP, so we don't need additional linting here
  -- javascript = { 'eslint' },  -- Using ESLint LSP instead
  -- typescript = { 'eslint' },  -- Using ESLint LSP instead

  -- Additional linting for shell scripts (shellcheck already via LSP)
  -- Add custom linters here if needed
}

-- Lint on file save
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    -- Only lint if there are linters configured for this filetype
    if #require('lint').linters_by_ft[vim.bo.filetype] > 0 then
      require("lint").try_lint()
    end
  end,
})
EOF
