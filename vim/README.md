# Modern Neovim Configuration

A batteries-included Neovim configuration with native LSP support for Python (with uv), JavaScript/TypeScript, Go, and ShellScript.

## Quick Start

### 1. Install Dependencies

```bash
# Required
brew install neovim ripgrep fd

# For Python (recommended)
brew install uv

# For JavaScript/TypeScript
brew install node

# For Clojure (optional)
brew install borkdude/brew/clj-kondo
```

### 2. Install Configuration

```bash
cd vim
make install
```

This installs vim-plug, all Neovim plugins, and sets up the configuration. LSP servers will be installed automatically when you first open a file.

### 3. Verify Installation

```bash
nvim
```

Inside Neovim:

```vim
:checkhealth
:Mason
:LspInfo
```

## Features

### Language Support

- **Python** 🐍

  - Pyright LSP (type checking, autocomplete)
  - Ruff (linting + formatting)
  - **Automatic uv virtual environment detection**
  - Auto-organize imports on save

- **JavaScript/TypeScript** 📜

  - TypeScript language server (ts_ls)
  - ESLint auto-fix on save
  - Prettier formatting
  - Full React/Vue/JSX/TSX support
  - JSON/HTML/CSS language servers

- **Go** 🔷

  - gopls (official Go language server)
  - gofumpt formatting + organize imports
  - vim-go for :GoBuild, :GoTest, :GoRun, :GoCoverage
  - All LSP features + Go-specific commands

- **ShellScript** 🐚

  - Bash language server
  - Shellcheck linting
  - shfmt formatting

- **Other Languages**
  - Clojure (Conjure + clojure-lsp)
  - JSON, HTML, CSS, Markdown
  - Treesitter syntax highlighting for all

### Modern Tools

- 🚀 **Native LSP** - Fast, built-in language server protocol
- 🔍 **Telescope** - Fuzzy finder (replaces CtrlP)
- 🌳 **Treesitter** - Advanced syntax highlighting
- ✨ **nvim-cmp** - Smart completion
- 🎨 **conform.nvim** - Auto-format on save
- 📦 **Mason** - Easy LSP/formatter/linter installation
- 🔧 **Trouble** - Better diagnostics UI

## Essential Keybindings

**File Navigation (Telescope):**

- `Ctrl+P` - Find files
- `,fg` - Live grep (search in files)
- `,fb` - Browse buffers
- `,fr` - Recent files
- `,fs` - LSP document symbols

**LSP (all languages):**

- `gd` - Go to definition
- `gr` - Find references
- `K` - Show documentation
- `,rn` - Rename symbol
- `,ca` - Code actions
- `,f` - Format buffer
- `[d` / `]d` - Navigate diagnostics

**Diagnostics:**

- `,e` - Show diagnostic float
- `,xx` - Toggle Trouble diagnostics
- `,xw` - Workspace diagnostics

**Completion:**

- `Tab` / `Shift+Tab` - Navigate completion
- `Enter` - Confirm
- `Ctrl+Space` - Trigger manually

**Go-specific** (in addition to LSP):

- `,b` - Build/test current file
- `,r` - Run Go program
- `,t` - Run tests
- `,c` - Toggle coverage
- `,a` - Alternate code/test file
- `,gf` - Fill struct fields
- `,ge` - Generate if err != nil

## Language-Specific Guides

### Python with uv

The configuration automatically detects uv virtual environments:

```bash
# Create a new project
mkdir myproject && cd myproject
uv init
uv venv
uv add requests

# Open in Neovim - LSP will auto-detect .venv
nvim main.py
```

**Virtual environment detection order:**

1. `.venv` in project root (uv default)
2. `venv` in project root
3. `$VIRTUAL_ENV` environment variable
4. System Python

**Features:**

- Autocomplete with type hints
- Go to definition (even in installed packages)
- Auto-organize imports on save
- Format with ruff on save
- Real-time linting

### JavaScript/TypeScript

Works with any project that has a `package.json`:

```bash
# In your project
npm install --save-dev prettier eslint

# Open a file
nvim app.js
```

**Features:**

- TypeScript-like autocomplete (even for .js files)
- ESLint diagnostics and auto-fix on save
- Prettier formatting on save
- Full JSX/TSX support
- Import autocomplete

### Go

```bash
# In your Go project
nvim main.go
```

**LSP Features (via gopls):**

- Smart autocomplete with type info
- Go to definition/implementation
- Find all references
- Rename refactoring
- Format + organize imports on save
- Inlay hints (types, parameters)

**vim-go Commands:**

- `:GoBuild` - Build project
- `:GoTest` - Run tests
- `:GoRun` - Run program
- `:GoCoverage` - Toggle coverage
- `:GoFillStruct` - Fill struct fields
- `:GoIfErr` - Generate error handling

### Shell Scripts

```bash
nvim deploy.sh
```

**Features:**

- Shellcheck warnings
- Bash language server (autocomplete, hover)
- shfmt formatting (2-space indent)
- Function/variable navigation

## Installation Details

### What Gets Installed

**Plugins via vim-plug:**

- LSP: nvim-lspconfig, mason.nvim, mason-lspconfig
- Completion: nvim-cmp, LuaSnip
- Formatting: conform.nvim
- Syntax: nvim-treesitter
- Navigation: telescope.nvim, NERDTree
- UI: trouble.nvim, vim-airline
- Git: vim-fugitive, vim-gitgutter

**LSP Servers via Mason (auto-installed):**

- Python: pyright, ruff
- JavaScript/TypeScript: ts_ls, eslint-lsp
- Go: gopls
- Shell: bash-language-server, shellcheck
- Web: jsonls, html, cssls
- Formatters: prettier, shfmt

### Manual Installation of LSP Servers

If you want to pre-install LSP servers:

```bash
# Via Makefile
make mason-install

# Or in Neovim
:Mason
# Press 'i' to install missing packages
```

## Configuration

### Customization

Edit `src/local.vim` for personal settings:

```vim
" Example: Disable format on save for a specific filetype
autocmd FileType python let b:disable_autoformat = 1

" Example: Custom keybindings
nnoremap <leader>ff :Telescope find_files<CR>
```

### Format on Save

Enabled by default for all languages. To disable for a buffer:

```vim
:let b:disable_autoformat = 1
```

To disable globally for a filetype, add to `src/local.vim`:

```vim
autocmd FileType javascript let b:disable_autoformat = 1
```

### Python Virtual Environments

To use a custom Python path:

```vim
:lua vim.g.python3_host_prog = '/path/to/python'
```

Or set in `src/local.vim`:

```vim
let g:python3_host_prog = '/path/to/python'
```

## Updating

```bash
# Update plugins
make plug-update

# Update LSP servers
make mason-update

# Or in Neovim
:PlugUpdate
:Mason
```

## Troubleshooting

### LSP Not Starting

**Check if LSP server is installed:**

```vim
:Mason
```

**Check LSP status:**

```vim
:LspInfo
```

**View LSP logs:**

```vim
:lua vim.cmd('e ' .. vim.lsp.get_log_path())
```

### Python Not Using uv Virtual Environment

**Check detected Python path:**

```vim
:lua print(vim.g.python3_host_prog)
```

Should show `/path/to/project/.venv/bin/python`

**Ensure .venv exists:**

```bash
ls -la .venv/bin/python
```

### Completion Not Working

**Verify nvim-cmp is loaded:**

```vim
:lua print(vim.inspect(require('cmp').config))
```

**Check LSP capabilities:**

```vim
:LspInfo
```

### Format on Save Not Working

**Check conform.nvim:**

```vim
:lua print(vim.inspect(require("conform").list_formatters()))
```

**Try manual format:**

```vim
:Format
```

### General Health Check

```vim
:checkhealth
```

This will show any issues with your Neovim setup.

## Migration from Old Setup

This configuration replaces:

- ❌ CoC.nvim → ✅ Native LSP
- ❌ ALE → ✅ conform.nvim + LSP diagnostics
- ❌ Syntastic → ✅ LSP diagnostics
- ❌ Deoplete → ✅ nvim-cmp
- ❌ CtrlP → ✅ Telescope

### Key Binding Changes

Most keybindings remain the same:

- `Ctrl+P` - Still find files (now with Telescope)
- `gd`, `gr`, `K` - Same for LSP
- `<leader>rn` - Still rename (was CoC, now LSP)
- `<leader>ca` - Code actions (was `<leader>ac` in CoC)

### What to Expect

1. **First launch**: Mason will install LSP servers (takes 1-2 minutes)
2. **Faster startup**: No Node.js/CoC overhead
3. **Better Python linting**: Ruff is much faster than traditional linters
4. **More features**: Inlay hints, better refactoring, code lens

## Performance

Expected improvements over CoC-based setup:

- **Startup time**: ~30% faster (no Node.js overhead)
- **Python linting**: 10-100x faster (Ruff vs pylint/flake8)
- **Completion**: Comparable or faster
- **Memory usage**: Lower (native LSP vs Node.js)

## Requirements

- **Neovim 0.9.0+** (required)
- **ripgrep** - For Telescope file searching
- **fd** - For faster file indexing (optional)
- **Node.js** - For JavaScript/TypeScript development
- **uv** - For Python virtual environment management (recommended)
- **Go** - For Go development (optional)

## Project Structure

```
vim/
├── Makefile              # Installation and maintenance
├── README.md            # This file
├── src/
│   ├── basic*.vim       # Basic Vim settings
│   ├── plug.vim         # Plugin list
│   ├── plug-*.vim       # Plugin configurations
│   ├── lsp-*.vim        # LSP configurations
│   ├── theme-*.vim      # Color scheme
│   └── local.vim        # Your custom settings
```

## Additional Commands

```bash
# Clean everything and reinstall
make clean
make install

# Update dependencies
make deps

# Update plugins
make plug-update

# Update LSP servers
make mason-update
```

## Getting Help

1. Run `:checkhealth` to diagnose issues
2. Check `:LspInfo` for LSP status
3. View logs: `:lua vim.cmd('e ' .. vim.lsp.get_log_path())`
4. Open `:Mason` to manage LSP servers

## Credits

This configuration uses:

- [Neovim](https://neovim.io/) - Hyperextensible Vim-based text editor
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP configurations
- [Mason](https://github.com/williamboman/mason.nvim) - Package manager
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - Completion engine
- [Telescope](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder
- [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Syntax parser
- And many other excellent plugins!

## License

MIT License - Feel free to use and modify as needed.
