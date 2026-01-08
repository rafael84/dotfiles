# Dotfiles

Vim and Emacs configurations for development. MacOS only.

## Installation

```bash
cd /path/to/dotfiles

# Vim (Neovim) - Multi-language development
make install-vim

# Emacs - Clojure focused
make install-emacs
```

**What it does:**
- Checks/installs dependencies (via Homebrew)
- Backs up existing configs (timestamped)
- Creates symlinks to this repo

## Structure

```
vim/
├── init.lua              # Main config
└── lua/
    ├── config/           # Options, keymaps, autocmds
    └── plugins/          # LSP, completion, languages

emacs/
├── init.el               # Main config (546 lines)
└── early-init.el         # Performance optimizations

~/.config/nvim → vim/     # Symlinks
~/.emacs.d → emacs/
```

## Vim Keys

Leader: `,` (press it to see all bindings)

| Key          | Action               |
| ------------ | -------------------- |
| `<C-p>`      | Find files           |
| `<Leader>fg` | Search in files      |
| `<F2>`       | Toggle file tree     |
| `gd`         | Go to definition     |
| `K`          | Documentation        |
| `<Leader>fm` | Format file          |
| `<Leader>xx` | Show diagnostics     |

**Python:** `<Leader>r` run, `<Leader>R` debug
**Go:** `<Leader>r` run, `<Leader>t` test
**C:** `<Leader>b` build, `<Leader>r` build+run

## Emacs Keys

Leader: `SPC` (press it to see all bindings)

| Key       | Action                |
| --------- | --------------------- |
| `SPC SPC` | Command prompt        |
| `SPC f f` | Find file             |
| `SPC p f` | Find file in project  |
| `SPC g s` | Git status (Magit)    |
| `SPC p t` | Toggle file tree      |

**Clojure** (`,` in .clj files):

| Key    | Action              |
| ------ | ------------------- |
| `, '`  | CIDER jack-in       |
| `, e e`| Eval last sexp      |
| `, e b`| Eval buffer         |
| `, t a`| Run namespace tests |
| `, r s`| Switch to REPL      |

## Commands

### Vim

```bash
make install-vim        # Full setup
make link-vim           # Just symlinks
make unlink-vim         # Remove symlinks
make update             # Update plugins
make clean              # Remove plugins
```

### Emacs

```bash
make install-emacs      # Full setup
make link-emacs         # Just symlinks
make unlink-emacs       # Remove symlinks
make check-deps-emacs   # Check dependencies
```

## What's Included

### Vim
- **LSP**: Python, Go, JS/TS, C, Clojure
- **Tools**: Telescope, NERDTree, Treesitter, Mason, Neotest, Trouble
- **Formatters**: conform.nvim with language-specific formatters

### Emacs
- **Focus**: Clojure development (CIDER, clojure-lsp)
- **Core**: Evil (vim bindings), Helm, Projectile, Magit, Company
- **Performance**: 2-3s startup, 30 packages (vs Spacemacs: 5-10s, 200+ packages)

## Customization

### Vim

Edit files in `vim/lua/`:
- `config/options.lua` - Editor settings
- `config/keymaps.lua` - Key bindings
- `plugins/init.lua` - Plugin list
- `plugins/languages/<lang>.lua` - Language-specific config

### Emacs

Edit `emacs/init.el` - everything is in one file (546 lines).

For machine-specific settings, create `~/.emacs.d/custom.el` (not tracked).

## Project-Local Config (Vim)

Create `.nvim.lua` in any project:

```lua
-- .nvim.lua
vim.g.c_make_target = 'tests'
vim.g.c_binary_path = 'bin/app-tests'
vim.g.c_binary_args = '--verbose'
```

Config auto-reloads when switching files. Commands: `:ProjectConfigShow`, `:ProjectConfigReload`

## Troubleshooting

| Problem                 | Solution                          |
| ----------------------- | --------------------------------- |
| Vim plugins not loading | `make clean && make install-vim`  |
| Vim LSP not working     | `:Mason` then `:LspInfo`          |
| Emacs packages failing  | `M-x package-refresh-contents`    |
| Emacs LSP not working   | `brew install clojure-lsp/brew/clojure-lsp-native` |
| Font not found          | Install Fira Code or edit config  |

## Portability

Both configs are fully portable:
- No hardcoded paths
- Clone anywhere, run `make install-*`
- Symlinks adapt automatically
- Works on any machine with dependencies installed

## License

Personal config. Use freely.
