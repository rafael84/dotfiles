-- ============================================================================
-- Vim Options and Settings
-- ============================================================================

local opt = vim.opt
local g = vim.g

-- ============================================================================
-- Leader Keys
-- ============================================================================

g.mapleader = ","
g.maplocalleader = " "

-- ============================================================================
-- General
-- ============================================================================

opt.compatible = false                    -- Disable vi compatibility
opt.history = 700                         -- Command history
opt.encoding = 'utf-8'                    -- UTF-8 encoding
opt.fileformats = { 'unix', 'dos', 'mac' } -- File format preference

-- ============================================================================
-- Files and Backups
-- ============================================================================

opt.backup = false                        -- No backup files
opt.writebackup = false                   -- No backup before writing
opt.swapfile = false                      -- No swap files

-- Session options
opt.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize'

-- ============================================================================
-- UI and Display
-- ============================================================================

opt.number = true                         -- Show line numbers
opt.cursorline = true                     -- Highlight current line
opt.ruler = true                          -- Show cursor position
opt.showcmd = true                        -- Show partial commands
opt.showmatch = false                     -- Don't show matching brackets
opt.lazyredraw = true                     -- Don't redraw during macros
opt.scrolloff = 999                       -- Keep cursor centered vertically
opt.signcolumn = 'yes'                    -- Always show sign column
opt.colorcolumn = ''                      -- No color column
opt.foldcolumn = '0'                      -- No fold column

-- Split directions
opt.splitright = true                     -- Vertical splits go right
opt.splitbelow = true                     -- Horizontal splits go below

-- Wildmenu
opt.wildmenu = true                       -- Command-line completion
opt.wildmode = 'list:longest,full'        -- Completion mode

-- Ignore files
opt.wildignore:append({ '*.o', '*~', '*.pyc', '*.git/*', '*.hg/*', '*.svn/*', '*.DS_Store' })

-- ============================================================================
-- Search
-- ============================================================================

opt.ignorecase = true                     -- Case-insensitive search
opt.smartcase = true                      -- Unless uppercase used
opt.hlsearch = true                       -- Highlight search results
opt.incsearch = true                      -- Incremental search
opt.magic = true                          -- Magic regex patterns

-- ============================================================================
-- Editing
-- ============================================================================

opt.backspace = { 'eol', 'start', 'indent' } -- Backspace behavior
opt.whichwrap:append('<,>,h,l')           -- Wrap cursor to next/prev line

-- Indentation
opt.expandtab = true                      -- Spaces instead of tabs
opt.smarttab = true                       -- Smart tab behavior
opt.shiftwidth = 4                        -- Indent width
opt.tabstop = 4                           -- Tab width
opt.shiftround = true                     -- Round indent to shiftwidth
opt.autoindent = true                     -- Auto indent
opt.smartindent = true                    -- Smart indent
opt.wrap = false                          -- Don't wrap lines

-- Text formatting
opt.linebreak = true                      -- Break lines at word boundaries
opt.textwidth = 500                       -- Max line width

-- ============================================================================
-- Completion
-- ============================================================================

opt.completeopt = { 'menuone', 'noselect' } -- Completion options
opt.infercase = true                      -- Infer case in completion

-- ============================================================================
-- Performance
-- ============================================================================

opt.updatetime = 300                      -- Faster completion
opt.timeoutlen = 500                      -- Faster key sequence completion
opt.ttimeoutlen = 10                      -- Faster escape time

-- ============================================================================
-- Mouse
-- ============================================================================

opt.mouse = 'a'                           -- Enable mouse support

-- ============================================================================
-- Clipboard
-- ============================================================================

if vim.fn.has('unnamedplus') == 1 then
  opt.clipboard = 'unnamedplus,unnamed'   -- Use system clipboard
else
  opt.clipboard:append('unnamed')
end

-- ============================================================================
-- Format Options
-- ============================================================================

opt.formatoptions:remove({ 'c', 'r', 'o' }) -- Don't continue comments on newline

-- ============================================================================
-- Number Formats (for Ctrl-A/Ctrl-X)
-- ============================================================================

opt.nrformats = { 'octal', 'hex', 'alpha' } -- Support for octal, hex, and alpha

-- ============================================================================
-- Folding (with Treesitter)
-- ============================================================================

opt.foldmethod = 'expr'                   -- Use expression for folding
opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()' -- Treesitter folding
opt.foldenable = false                    -- Don't fold by default
opt.foldlevel = 99                        -- Start with all folds open

-- ============================================================================
-- Visuals
-- ============================================================================

opt.termguicolors = true                  -- True color support
opt.background = 'dark'                   -- Dark background

-- Disable bells
opt.errorbells = false
opt.visualbell = false

-- ============================================================================
-- Buffers and Tabs
-- ============================================================================

opt.hidden = false                        -- Don't keep hidden buffers
opt.switchbuf = { 'useopen', 'usetab', 'newtab' } -- Buffer switching behavior
opt.showtabline = 2                       -- Always show tab line

-- ============================================================================
-- Command Line
-- ============================================================================

opt.cmdheight = 0                         -- Hide command line when not in use

-- ============================================================================
-- LSP and Diagnostics
-- ============================================================================

-- Diagnostic signs are configured in plugins/lsp.lua
