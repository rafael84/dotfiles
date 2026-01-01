-- ============================================================================
-- Spec Viewer - Display spec/reference files in a fixed right-side window
-- ============================================================================

local M = {}

-- Configuration
local config = {
  width = 80,              -- Width of the spec window
  position = 'right',      -- Position: 'right' or 'left'
  readonly = false,         -- Make the spec window read-only
  relative_width = 0.3,    -- Use percentage of screen width (e.g., 0.3 for 30%)
}

-- State
local spec_bufnr = nil
local spec_winnr = nil
local spec_filepath = nil

-- Get the actual width to use
local function get_width()
  if config.relative_width then
    return math.floor(vim.o.columns * config.relative_width)
  end
  return config.width
end

-- Check if spec window is open
local function is_spec_window_open()
  if spec_winnr and vim.api.nvim_win_is_valid(spec_winnr) then
    return true
  end
  spec_winnr = nil
  return false
end

-- Close the spec window
function M.close()
  if is_spec_window_open() then
    -- Check if this is the last window before closing
    local win_count = #vim.api.nvim_list_wins()
    if win_count > 1 then
      vim.api.nvim_win_close(spec_winnr, true)
      spec_winnr = nil
    else
      vim.notify("Cannot close last window", vim.log.levels.WARN)
    end
  end
end

-- Open or refresh the spec window
function M.open(filepath)
  -- If filepath provided, update it
  if filepath and filepath ~= '' then
    spec_filepath = vim.fn.expand(filepath)
  else
    -- If no filepath provided, use current buffer's file
    local current_file = vim.api.nvim_buf_get_name(0)
    if current_file == '' then
      vim.notify("No file to open. Current buffer has no file.", vim.log.levels.ERROR)
      return
    end
    spec_filepath = current_file
  end

  -- Check if we have a filepath
  if not spec_filepath then
    vim.notify("No spec file set.", vim.log.levels.ERROR)
    return
  end

  -- Check if file exists
  if vim.fn.filereadable(spec_filepath) == 0 then
    vim.notify("File not found: " .. spec_filepath, vim.log.levels.ERROR)
    return
  end

  -- If window is already open, reuse it instead of closing and reopening
  if is_spec_window_open() then
    -- Save current window
    local current_win = vim.api.nvim_get_current_win()

    -- Switch to spec window and load the new file
    vim.api.nvim_set_current_win(spec_winnr)
    vim.cmd('edit ' .. vim.fn.fnameescape(spec_filepath))
    spec_bufnr = vim.api.nvim_get_current_buf()

    -- Reconfigure the buffer
    if config.readonly then
      vim.bo[spec_bufnr].readonly = true
      vim.bo[spec_bufnr].modifiable = false
    end
    vim.bo[spec_bufnr].buflisted = false
    vim.bo[spec_bufnr].bufhidden = 'hide'

    -- Return to the original window
    if current_win ~= spec_winnr and vim.api.nvim_win_is_valid(current_win) then
      vim.api.nvim_set_current_win(current_win)
    end

    vim.notify("Spec viewer opened: " .. vim.fn.fnamemodify(spec_filepath, ':t'))
    return
  end

  -- Determine split command
  local split_cmd = config.position == 'left' and 'topleft vsplit' or 'botright vsplit'

  -- Save current window
  local current_win = vim.api.nvim_get_current_win()

  -- Create the split and open the file
  vim.cmd(split_cmd .. ' ' .. vim.fn.fnameescape(spec_filepath))

  -- Get the new window
  spec_winnr = vim.api.nvim_get_current_win()
  spec_bufnr = vim.api.nvim_get_current_buf()

  -- Set window width
  vim.api.nvim_win_set_width(spec_winnr, get_width())

  -- Configure the window
  vim.wo[spec_winnr].wrap = true
  vim.wo[spec_winnr].linebreak = true
  vim.wo[spec_winnr].number = false
  vim.wo[spec_winnr].relativenumber = false
  vim.wo[spec_winnr].cursorline = true
  vim.wo[spec_winnr].winfixwidth = true  -- Fixed width

  -- Configure the buffer
  if config.readonly then
    vim.bo[spec_bufnr].readonly = true
    vim.bo[spec_bufnr].modifiable = false
  end
  vim.bo[spec_bufnr].buflisted = false
  vim.bo[spec_bufnr].bufhidden = 'hide'

  -- Add a highlight to make it visually distinct
  vim.api.nvim_win_set_option(spec_winnr, 'winhl', 'Normal:NormalFloat')

  -- Return to the original window
  vim.api.nvim_set_current_win(current_win)

  vim.notify("Spec viewer opened: " .. vim.fn.fnamemodify(spec_filepath, ':t'))
end

-- Toggle the spec window
function M.toggle()
  if is_spec_window_open() then
    M.close()
  else
    M.open()
  end
end

-- Reload the spec file content
function M.reload()
  if not is_spec_window_open() then
    vim.notify("Spec window is not open", vim.log.levels.WARN)
    return
  end

  local current_win = vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(spec_winnr)

  -- Temporarily make it modifiable
  vim.bo[spec_bufnr].readonly = false
  vim.bo[spec_bufnr].modifiable = true

  -- Reload
  vim.cmd('edit!')

  -- Restore settings
  if config.readonly then
    vim.bo[spec_bufnr].readonly = true
    vim.bo[spec_bufnr].modifiable = false
  end

  vim.api.nvim_set_current_win(current_win)
  vim.notify("Spec file reloaded")
end

-- Focus the spec window
function M.focus()
  if is_spec_window_open() then
    vim.api.nvim_set_current_win(spec_winnr)
  else
    vim.notify("Spec window is not open", vim.log.levels.WARN)
  end
end

-- Setup function
function M.setup(opts)
  -- Merge user config
  if opts then
    config = vim.tbl_extend('force', config, opts)
  end

  -- Commands
  vim.api.nvim_create_user_command('SpecOpen', function(args)
    M.open(args.args)
  end, {
    nargs = '?',
    complete = 'file',
    desc = 'Open spec file in side window (uses current file if no argument)'
  })

  vim.api.nvim_create_user_command('SpecClose', function()
    M.close()
  end, { desc = 'Close spec window' })

  vim.api.nvim_create_user_command('SpecToggle', function()
    M.toggle()
  end, { desc = 'Toggle spec window' })

  vim.api.nvim_create_user_command('SpecReload', function()
    M.reload()
  end, { desc = 'Reload spec file' })

  vim.api.nvim_create_user_command('SpecFocus', function()
    M.focus()
  end, { desc = 'Focus spec window' })

  -- Keymaps are defined in config/keymaps.lua

  -- Auto-command to maintain fixed width on resize
  vim.api.nvim_create_autocmd('VimResized', {
    callback = function()
      if is_spec_window_open() and config.relative_width then
        vim.api.nvim_win_set_width(spec_winnr, get_width())
      end
    end,
    desc = 'Maintain spec window width on resize'
  })
end

return M
