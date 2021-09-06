" Editor
Plug 'schickling/vim-bufonly'
Plug 'vim-scripts/Tabmerge'
Plug 'editorconfig/editorconfig-vim'
Plug 'AndrewRadev/sideways.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'airblade/vim-gitgutter'
Plug 'bronson/vim-visual-star-search'
Plug 'terryma/vim-multiple-cursors'
Plug 'tmhedberg/matchit'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'dhruvasagar/vim-zoom'

" Navigation and Search
Plug 'mileszs/ack.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'jremmen/vim-ripgrep'
Plug 'k0kubun/vim-open-github'

" Syntax highlighting
Plug 'flazz/vim-colorschemes'
Plug 'inkarkat/vim-SyntaxRange'
Plug 'jiangmiao/auto-pairs'
Plug 'luochen1990/rainbow'

" General
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'Raimondi/delimitMate'
Plug 'Shougo/echodoc.vim'
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-easy-align'
Plug 'matze/vim-move'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-scripts/AnsiEsc.vim'

" Auto complete
Plug 'vim-syntastic/syntastic'
Plug 'w0rp/ale'
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins', 'for': 'go' }
else
  Plug 'Shougo/deoplete.nvim', {'for': 'go'}
  Plug 'roxma/nvim-yarp', {'for': 'go'}
  Plug 'roxma/vim-hug-neovim-rpc', {'for': 'go'}
endif
Plug 'zchee/deoplete-go', { 'do': 'make', 'for': 'go'}

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

" Web
Plug 'mxw/vim-jsx'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'

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
