-- ============================================================================
-- General Utility Functions
-- ============================================================================
-- General utility functions used across the configuration
-- These are called from keymaps.lua and other modules

local M = {}

-- ============================================================================
-- Messages
-- ============================================================================

-- Open Neovim :messages in a buffer
function M.open_messages()
  local messages = vim.fn.execute('messages')
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(messages, '\n'))
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'filetype', 'messages')
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.cmd('vsplit')
  vim.api.nvim_win_set_buf(0, buf)
end

-- ============================================================================
-- Config Reload
-- ============================================================================

-- Reload Neovim configuration
function M.reload_config()
  for name, _ in pairs(package.loaded) do
    if name:match('^config') or name:match('^plugins') then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
  vim.notify("Config reloaded!", vim.log.levels.INFO)
end

-- ============================================================================
-- Search Utilities
-- ============================================================================

-- Search word under cursor with Ripgrep
function M.ripgrep_current_word()
  local word = vim.fn.expand('<cword>')
  vim.cmd('Rg ' .. word)
end

-- Search visual selection with Ripgrep
function M.ripgrep_visual_selection()
  -- Yank current visual selection
  local saved_reg = vim.fn.getreg('v')
  vim.cmd('normal! "vy')
  local selection = vim.fn.getreg('v')
  vim.fn.setreg('v', saved_reg)

  -- Escape special characters for ripgrep
  selection = vim.fn.shellescape(selection)
  vim.cmd('Rg ' .. selection)
end

return M
