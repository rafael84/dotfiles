# Dotfiles

Modern neovim configuration with LSP, completion, fuzzy finding, and testing. MacOS only.

## Quick Start

```bash
cd ~/dotfiles
make install
nvim
```

Done. Press `<Leader>` (comma) in nvim to see all keybindings.

## Structure

```
vim/
├── init.lua              # Loads everything
├── lua/config/           # Vim settings, keymaps, autocommands
└── lua/plugins/          # Plugin configs
    ├── init.lua          # Plugin list (add plugins here)
    ├── lsp.lua           # LSP base
    ├── completion.lua    # Auto-completion
    ├── treesitter.lua    # Syntax highlighting
    ├── formatting.lua    # Code formatting
    ├── testing.lua       # Test runner
    └── languages/        # Language-specific (go, python, js, clojure)
```

## Makefile Commands

| Command | Action |
|---------|--------|
| `make install` | Full setup (deps + link + plugins) |
| `make update` | Update everything |
| `make clean` | Remove plugins |
| `make link` | Create symlinks |
| `make unlink` | Remove symlinks |

## Essential Keybindings

Leader: `,` (comma)

| Key | Action |
|-----|--------|
| `<Leader>` | Show all keybindings |
| `<C-p>` | Find files |
| `<Leader>fg` | Search in files |
| `<Leader>fb` | List buffers |
| `<F2>` | Toggle file tree |
| `gd` | Go to definition |
| `gr` | Show references |
| `K` | Documentation |
| `<Leader>rn` | Rename |
| `<Leader>ca` | Code action |
| `<Leader>fm` | Format file |
| `<Leader>xx` | Show diagnostics |
| `[d` / `]d` | Previous/next diagnostic |
| `<Leader>tn` | Run nearest test |
| `<Leader>tf` | Run test file |

Press `<Leader>` and wait to see everything.

## Common Tasks

### Edit Settings

| Task | File | Example |
|------|------|---------|
| Change tabs | `config/options.lua` | `opt.tabstop = 2` |
| Add keybinding | `config/keymaps.lua` | `map('n', '<Leader>x', ':Command<CR>', opts)` |
| Add plugin | `plugins/init.lua` | `vim.fn['plug#']('author/plugin')` then `:PlugInstall` |
| Configure Go | `plugins/languages/go.lua` | Edit gopls settings |
| Configure Python | `plugins/languages/python.lua` | Edit pyright settings |

### Install LSP Server

```
:Mason
```

Press `i` to install, `X` to uninstall.

### Update Everything

```bash
make update
```

### Check Health

```
:checkhealth
```

## Troubleshooting

### Conflicting init.vim

```bash
mv ~/.config/nvim/init.vim ~/.config/nvim/init.vim.old
```

Or:

```bash
make unlink && make link
```

### Plugins Not Loading

```bash
make clean && make install
```

### LSP Not Working

1. `:Mason` - verify server installed
2. `:LspInfo` - check status
3. `:checkhealth lsp` - diagnose

### Syntax Highlighting Off

```
:TSUpdate
:TSInstall <language>
```

## Customization

### Local Overrides (Not in Git)

Create `~/.vimrc.local`:

```lua
vim.opt.relativenumber = true
vim.g.custom_setting = 'value'
```

### Add Plugin

Edit `vim/lua/plugins/init.lua`:

```lua
vim.fn['plug#']('author/plugin-name')
```

Run `:PlugInstall` or `make update`.

### Modify Plugin Config

Find the plugin in `plugins/` and edit. Example: `plugins/ui.lua` for airline, colorscheme, etc.

## What's Included

**Editor**: Surround, commentary, auto-pairs, easy-align, splitjoin

**Navigation**: Telescope (fuzzy finder), NERDTree, ripgrep

**LSP**: Python (pyright, ruff), Go (gopls), JS/TS (ts_ls, eslint), Clojure (clojure_lsp)

**Completion**: nvim-cmp with LSP, snippets, buffer, path

**Syntax**: Treesitter for all major languages

**Formatting**: conform.nvim (prettier, ruff, gofumpt, stylua, shfmt)

**Testing**: Neotest (pytest, go test, jest, vitest)

**Diagnostics**: Trouble.nvim, which-key

**UI**: Airline, git gutter, rainbow parens, colorschemes

## Migration from Old .vimrc

Your 1,784-line `.vimrc` is now split into 20 organized files. Everything works the same, just easier to find and modify.

Old config backed up at `/Users/rafael.lopes/dotfiles/.vimrc`

## Dependencies

Auto-installed by `make install`:
- neovim
- ripgrep
- fd
- node
- git

Language servers auto-installed by Mason on first use.

## Tips

- Press `<Leader>` frequently to discover keybindings
- Use `:Telescope commands` to find commands
- Tab-complete everything in command mode
- Run `:checkhealth` after changes
- Read one config file per day to learn

## Need Help?

- In nvim: Press `<Leader>` and wait
- Check health: `:checkhealth`
- Find commands: `:Telescope commands`
- Plugin docs: `:help <plugin-name>`

## License

Personal configuration. Use freely.
