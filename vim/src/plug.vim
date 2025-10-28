" Editor
Plug 'schickling/vim-bufonly'
Plug 'vim-scripts/Tabmerge'
Plug 'editorconfig/editorconfig-vim'
Plug 'AndrewRadev/sideways.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'airblade/vim-gitgutter'
Plug 'bronson/vim-visual-star-search'
Plug 'tmhedberg/matchit'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'dhruvasagar/vim-zoom'

" Navigation and Search
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'scrooloose/nerdtree'
Plug 'jremmen/vim-ripgrep'
Plug 'k0kubun/vim-open-github'

" Syntax highlighting and Treesitter
Plug 'flazz/vim-colorschemes'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'jiangmiao/auto-pairs'
Plug 'luochen1990/rainbow'

" General
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-easy-align'
Plug 'matze/vim-move'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-scripts/AnsiEsc.vim'
Plug 'folke/which-key.nvim'

" LSP and Completion
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'b0o/schemastore.nvim'

" Formatting and Linting
Plug 'stevearc/conform.nvim'
Plug 'mfussenegger/nvim-lint'

" Diagnostics UI
Plug 'folke/trouble.nvim'
Plug 'nvim-tree/nvim-web-devicons'

" Testing
Plug 'nvim-neotest/neotest'
Plug 'nvim-neotest/nvim-nio'
Plug 'nvim-neotest/neotest-python'
Plug 'nvim-neotest/neotest-go'
Plug 'nvim-neotest/neotest-jest'
Plug 'marilari88/neotest-vitest'

" Go
Plug 'fatih/vim-go', {'do': ':GoUpdateBinaries', 'for': 'go'}
Plug 'majutsushi/tagbar'

" Clojure
Plug 'tpope/vim-fireplace', {'for': 'clojure'}
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'vim-scripts/paredit.vim'
Plug 'snoe/clj-refactor.nvim', { 'do': 'yarn global add neovim' }
Plug 'Olical/conjure', {'tag': 'v4.5.0'}
Plug 'bakpakin/fennel.vim'

" Web (now handled by Treesitter)
Plug 'othree/html5.vim'

" Misc Languages
Plug 'keith/swift.vim'
Plug 'amadeus/vim-mjml'
Plug 'udalov/kotlin-vim'
Plug 'chase/vim-ansible-yaml'
Plug 'dart-lang/dart-vim-plugin'
Plug 'ekalinin/Dockerfile.vim'
Plug 'hashivim/vim-terraform'
Plug 'juliosueiras/vim-terraform-completion'
Plug 'leafgarland/typescript-vim'
Plug 'elzr/vim-json', {'for': 'json'}
Plug 'fatih/vim-nginx', {'for': 'nginx'}
