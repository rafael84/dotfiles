-- ============================================================================
-- Markdown Configuration - markdown-preview.nvim
-- ============================================================================
-- Plugin: https://github.com/iamcco/markdown-preview.nvim
--
-- Features:
-- - Live preview in browser with auto-refresh
-- - Supports KaTeX, mermaid, PlantUML, chart.js
-- - Synchronized scrolling
-- - Dark/light theme
-- ============================================================================

-- ============================================================================
-- General Settings
-- ============================================================================

-- Set to 1, nvim will open the preview window after entering the markdown buffer
-- Default: 0
vim.g.mkdp_auto_start = 0

-- Set to 1, the nvim will auto close current preview window when change
-- from markdown buffer to another buffer
-- Default: 1
vim.g.mkdp_auto_close = 1

-- Set to 1, the vim will refresh markdown when save the buffer or
-- leave from insert mode, default 0 is auto refresh markdown as you edit or
-- move the cursor
-- Default: 0
vim.g.mkdp_refresh_slow = 0

-- Set to 1, the MarkdownPreview command can be use for all files,
-- by default it can be use in markdown file
-- Default: 0
vim.g.mkdp_command_for_global = 0

-- Set to 1, preview server available to others in your network
-- by default, the server listens on localhost (127.0.0.1)
-- Default: 0
vim.g.mkdp_open_to_the_world = 0

-- Use custom IP to open preview page
-- useful when you work in remote vim and preview on local browser
-- more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
-- Default: ''
vim.g.mkdp_open_ip = ''

-- Specify browser to open preview page
-- for path with space
-- valid: `/path/with\ space/xxx`
-- invalid: `/path/with\\ space/xxx`
-- Default: ''
vim.g.mkdp_browser = ''

-- Set to 1, echo preview page url in command line when open preview page
-- Default: 0
vim.g.mkdp_echo_preview_url = 1

-- A custom vim function name to open preview page
-- this function will receive url as param
-- Default: ''
vim.g.mkdp_browserfunc = ''

-- ============================================================================
-- Preview Options
-- ============================================================================

vim.g.mkdp_preview_options = {
  mkit = {},
  katex = {},
  uml = {},
  maid = {},
  disable_sync_scroll = 0,
  sync_scroll_type = 'middle',
  hide_yaml_meta = 1,
  sequence_diagrams = {},
  flowchart_diagrams = {},
  content_editable = false,
  disable_filename = 0,
  toc = {}
}

-- Use a custom markdown style (must be absolute path)
-- Like: '/Users/username/markdown.css' or expand('~/markdown.css')
vim.g.mkdp_markdown_css = ''

-- Use a custom highlight style (must be absolute path)
-- Like: '/Users/username/highlight.css' or expand('~/highlight.css')
vim.g.mkdp_highlight_css = ''

-- Use a custom port to start server or empty for random
vim.g.mkdp_port = ''

-- Preview page title
-- ${name} will be replace with the file name
vim.g.mkdp_page_title = '「${name}」'

-- Recognized filetypes
-- These filetypes will have MarkdownPreview... commands
vim.g.mkdp_filetypes = { 'markdown' }

-- Set default theme (dark or light)
-- By default the theme is define according to the preferences of the system
vim.g.mkdp_theme = 'dark'

-- Combine preview window
-- Default: 0
-- if enable it will reuse previous opened preview window when you preview markdown file.
-- ensure to set let g:mkdp_auto_close = 0 if you have enable this option
vim.g.mkdp_combine_preview = 0

-- Auto refetch combine preview contents when change markdown buffer
-- only when g:mkdp_combine_preview is 1
vim.g.mkdp_combine_preview_auto_refresh = 1

-- ============================================================================
-- Keymaps
-- ============================================================================

-- Keymaps are defined in config/keymaps.lua

-- ============================================================================
-- Installation and Usage
-- ============================================================================
--
-- Installation:
--   1. Run :PlugInstall in Neovim
--   2. The plugin will automatically install dependencies (yarn + node modules)
--   3. Requires Node.js and yarn/npm
--
-- Usage:
--   - Open a .md file
--   - Press <leader>mp to toggle preview (default: ,mp)
--   - Or use :MarkdownPreview command
--   - Preview opens in default browser with live updates
--
-- Tips:
--   - Set updatetime to small number for faster sync: set updatetime=100
--   - Mouse over header in preview to change dark/light theme
--   - Supports: KaTeX math, mermaid diagrams, PlantUML, code highlighting
--
