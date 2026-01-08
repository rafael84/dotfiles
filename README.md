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
| `*`          | Search word forward  |
| `#`          | Search word backward |
| `<Leader>fm` | Format file          |
| `<Leader>xx` | Show diagnostics     |

**Python:** `<Leader>r` run, `<Leader>R` debug
**Go:** `<Leader>r` run, `<Leader>t` test
**C:** `<Leader>b` build, `<Leader>r` build+run

## Emacs Keys

Leader: `SPC` (wait 0.2s to see all bindings)

| Key         | Action                                |
| ----------- | ------------------------------------- |
| `SPC SPC`   | Command prompt (M-x)                  |
| `SPC /`     | Search in project (results at bottom) |
| `SPC f f`   | Find file                             |
| `SPC f r`   | Recent files                          |
| `SPC f s`   | Save file                             |
| `SPC f S`   | Save all files                        |
| `SPC f D`   | Delete file                           |
| `SPC f R`   | Rename file                           |
| `SPC f y`   | Copy file path                        |
| `SPC f e d` | Open config (init.el)                 |
| `SPC f e D` | Open early-init.el                    |
| `SPC f e R` | Reload config                         |
| `SPC p f`   | Find file in project                  |
| `SPC /`     | Search in project (rg)                |
| `SPC g s`   | Git status (Magit)                    |
| `SPC p t`   | Toggle file tree                      |
| `SPC q q`   | Quit Emacs                            |
| `SPC q r`   | Restart Emacs                         |
| `SPC j j`   | CIDER jack-in                         |
| `SPC j p`   | Jack-in with profile                  |
| `SPC a a`   | LSP code actions                      |
| `SPC a r`   | LSP rename                            |
| `SPC a f`   | LSP format buffer                     |
| `SPC a F`   | LSP find references                   |

**Navigation:**

| Key | Action               |
| --- | -------------------- |
| `*` | Search word forward  |
| `#` | Search word backward |
| `H` | Previous sexp        |
| `L` | Next sexp            |

**Structural editing** (Lisp languages):

| Key       | Action             |
| --------- | ------------------ |
| `SPC k $` | End of sexp        |
| `SPC k )` | Slurp forward      |
| `SPC k (` | Slurp backward     |
| `SPC k }` | Barf forward       |
| `SPC k {` | Barf backward      |
| `SPC k s` | Splice             |
| `SPC k r` | Raise              |
| `SPC k w` | Wrap with parens   |
| `SPC k [` | Wrap with brackets |

**Clojure** (`,` local leader in .clj files):

| Key     | Action                  |
| ------- | ----------------------- |
| `, e e` | Eval last sexp (before) |
| `, e v` | Eval sexp at point      |
| `, e i` | Inspect last result     |
| `, e f` | Eval top-level defun    |
| `, e b` | Eval buffer             |
| `, e r` | Eval region             |
| `, t a` | Run namespace tests     |
| `, n r` | Refresh namespace       |
| `, r s` | Switch to REPL          |
| `, r q` | Quit REPL               |

## Commands

```bash
# Vim
make install-vim        # Full setup
make link-vim           # Just symlinks
make unlink-vim         # Remove symlinks

# Emacs
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

| Problem                 | Solution                                           |
| ----------------------- | -------------------------------------------------- |
| Vim plugins not loading | `make clean && make install-vim`                   |
| Vim LSP not working     | `:Mason` then `:LspInfo`                           |
| Emacs packages failing  | `M-x package-refresh-contents`                     |
| Emacs LSP not working   | `brew install clojure-lsp/brew/clojure-lsp-native` |
| Font not found          | Install Fira Code or edit config                   |

## Portability

Both configs are fully portable:

- No hardcoded paths
- Clone anywhere, run `make install-*`
- Symlinks adapt automatically
- Works on any machine with dependencies installed

## License

Personal config. Use freely.
