-- ============================================================================
-- Plugin Manager Setup (vim-plug)
-- ============================================================================

-- Bootstrap vim-plug if not installed
local plug_path = vim.fn.stdpath('data') .. '/site/autoload/plug.vim'
if vim.fn.empty(vim.fn.glob(plug_path)) > 0 then
  vim.fn.system({
    'curl', '-fLo', plug_path, '--create-dirs',
    'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  })
  vim.cmd('autocmd VimEnter * PlugInstall --sync | source $MYVIMRC')
end

-- Plugin list
vim.call('plug#begin', vim.fn.stdpath('data') .. '/plugged')

-- ============================================================================
-- Editor Enhancement
-- ============================================================================

vim.fn['plug#']('tpope/vim-surround')                 -- Surround text objects
vim.fn['plug#']('tpope/vim-repeat')                   -- Repeat plugin mappings with .
vim.fn['plug#']('tpope/vim-commentary')               -- Comment stuff out
vim.fn['plug#']('tpope/vim-abolish')                  -- Smart substitution
vim.fn['plug#']('jiangmiao/auto-pairs')               -- Auto close brackets
vim.fn['plug#']('editorconfig/editorconfig-vim')      -- EditorConfig support
vim.fn['plug#']('AndrewRadev/sideways.vim')           -- Move function arguments
vim.fn['plug#']('junegunn/vim-easy-align')            -- Alignment plugin
vim.fn['plug#']('matze/vim-move')                     -- Move lines/blocks
vim.fn['plug#']('bronson/vim-visual-star-search')     -- Visual mode star search
vim.fn['plug#']('tmhedberg/matchit')                  -- Extended % matching
vim.fn['plug#']('schickling/vim-bufonly')             -- Close all but current buffer
vim.fn['plug#']('vim-scripts/Tabmerge')               -- Merge tabs
vim.fn['plug#']('ConradIrwin/vim-bracketed-paste')    -- Better paste handling
vim.fn['plug#']('dhruvasagar/vim-zoom')               -- Zoom splits

-- ============================================================================
-- Navigation and Search
-- ============================================================================

vim.fn['plug#']('nvim-lua/plenary.nvim')                                     -- Lua utilities
vim.fn['plug#']('nvim-telescope/telescope.nvim')                             -- Fuzzy finder (latest)
vim.fn['plug#']('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' }) -- FZF for Telescope
vim.fn['plug#']('scrooloose/nerdtree')                                       -- File tree
vim.fn['plug#']('jremmen/vim-ripgrep')                                       -- Ripgrep integration

-- ============================================================================
-- UI and Visual
-- ============================================================================

vim.fn['plug#']('vim-airline/vim-airline')            -- Statusline
vim.fn['plug#']('flazz/vim-colorschemes')             -- Color schemes
vim.fn['plug#']('airblade/vim-gitgutter')             -- Git diff in gutter
vim.fn['plug#']('luochen1990/rainbow')                -- Rainbow parentheses
vim.fn['plug#']('vim-scripts/AnsiEsc.vim')            -- ANSI escape codes
vim.fn['plug#']('nvim-tree/nvim-web-devicons')        -- Icons

-- ============================================================================
-- Syntax and Treesitter
-- ============================================================================

-- Note: nvim-treesitter-textobjects removed due to API incompatibility
-- If needed later, must pin both treesitter and textobjects to matching old versions
vim.fn['plug#']('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })

-- ============================================================================
-- LSP and Completion
-- ============================================================================

vim.fn['plug#']('neovim/nvim-lspconfig')              -- LSP configurations
vim.fn['plug#']('williamboman/mason.nvim')            -- LSP installer
vim.fn['plug#']('williamboman/mason-lspconfig.nvim') -- Mason + lspconfig bridge
vim.fn['plug#']('hrsh7th/nvim-cmp')                   -- Completion engine
vim.fn['plug#']('hrsh7th/cmp-nvim-lsp')               -- LSP completion source
vim.fn['plug#']('hrsh7th/cmp-buffer')                 -- Buffer completion source
vim.fn['plug#']('hrsh7th/cmp-path')                   -- Path completion source
vim.fn['plug#']('hrsh7th/cmp-cmdline')                -- Command-line completion
vim.fn['plug#']('L3MON4D3/LuaSnip')                   -- Snippet engine
vim.fn['plug#']('saadparwaiz1/cmp_luasnip')           -- Snippet completion source
vim.fn['plug#']('b0o/schemastore.nvim')               -- JSON schemas

-- ============================================================================
-- Formatting and Linting
-- ============================================================================

vim.fn['plug#']('stevearc/conform.nvim')              -- Formatting
vim.fn['plug#']('mfussenegger/nvim-lint')             -- Linting

-- ============================================================================
-- Diagnostics and UI
-- ============================================================================

vim.fn['plug#']('folke/trouble.nvim')                 -- Better diagnostics UI
vim.fn['plug#']('folke/which-key.nvim')               -- Show keybindings

-- ============================================================================
-- Testing
-- ============================================================================

vim.fn['plug#']('nvim-neotest/neotest')               -- Test runner
vim.fn['plug#']('nvim-neotest/nvim-nio')              -- Async IO for neotest
vim.fn['plug#']('nvim-neotest/neotest-python')        -- Python adapter
vim.fn['plug#']('nvim-neotest/neotest-go')            -- Go adapter
vim.fn['plug#']('nvim-neotest/neotest-jest')          -- Jest adapter
vim.fn['plug#']('marilari88/neotest-vitest')          -- Vitest adapter

-- ============================================================================
-- Git
-- ============================================================================

vim.fn['plug#']('tpope/vim-fugitive')                 -- Git integration
vim.fn['plug#']('tpope/vim-rhubarb')                  -- GitHub support for fugitive (enables :GBrowse)
vim.fn['plug#']('junegunn/gv.vim')                    -- Git commit browser

-- ============================================================================
-- Language-Specific Plugins
-- ============================================================================

-- Go
vim.fn['plug#']('fatih/vim-go', { ['do'] = ':GoUpdateBinaries', ['for'] = 'go' })
vim.fn['plug#']('majutsushi/tagbar')                  -- Code outline viewer

-- Clojure
vim.fn['plug#']('tpope/vim-fireplace', { ['for'] = 'clojure' })

-- S-expression editing (available globally for structural editing)
vim.fn['plug#']('guns/vim-sexp')
vim.fn['plug#']('tpope/vim-sexp-mappings-for-regular-people')

vim.fn['plug#']('vim-scripts/paredit.vim', { ['for'] = 'clojure' })
vim.fn['plug#']('Olical/conjure', { tag = 'v4.5.0' })
vim.fn['plug#']('bakpakin/fennel.vim')

-- Web
vim.fn['plug#']('othree/html5.vim')

-- Markdown
vim.fn['plug#']('iamcco/markdown-preview.nvim', { ['do'] = 'cd app && npx --yes yarn install' })

-- Misc Languages
vim.fn['plug#']('keith/swift.vim')
vim.fn['plug#']('amadeus/vim-mjml')
vim.fn['plug#']('udalov/kotlin-vim')
vim.fn['plug#']('chase/vim-ansible-yaml')
vim.fn['plug#']('dart-lang/dart-vim-plugin')
vim.fn['plug#']('ekalinin/Dockerfile.vim')
vim.fn['plug#']('hashivim/vim-terraform')
vim.fn['plug#']('juliosueiras/vim-terraform-completion')
vim.fn['plug#']('leafgarland/typescript-vim')
vim.fn['plug#']('elzr/vim-json', { ['for'] = 'json' })
vim.fn['plug#']('fatih/vim-nginx', { ['for'] = 'nginx' })

vim.call('plug#end')
