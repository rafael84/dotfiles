# Dotfiles

Neovim config with LSP, completion, and testing. MacOS only.

## Quick Start

```bash
cd ~/dotfiles
make install
nvim
```

Press `<Leader>` (comma) in nvim to see keybindings.

## Structure

```
vim/
├── init.lua
├── lua/config/           # Options, keymaps, autocommands
└── lua/plugins/
    ├── init.lua          # Plugin list
    ├── lsp.lua
    ├── completion.lua
    ├── treesitter.lua
    ├── formatting.lua
    ├── testing.lua
    ├── diagnostics.lua
    ├── editing.lua
    ├── navigation.lua
    ├── ui.lua
    └── languages/        # C, Go, Python, JS, Clojure
```

## Commands

| Command        | Action         |
| -------------- | -------------- |
| `make install` | Full setup     |
| `make update`  | Update all     |
| `make clean`   | Remove plugins |

## Essential Keys

Leader: `,`

| Key          | Action               |
| ------------ | -------------------- |
| `<Leader>`   | Show all keys        |
| `<C-p>`      | Find files           |
| `<Leader>fg` | Search in files      |
| `<F2>`       | Toggle file tree     |
| `gd`         | Go to definition     |
| `K`          | Documentation        |
| `<Leader>rn` | Rename               |
| `<Leader>fm` | Format file          |
| `<Leader>xx` | Show diagnostics     |
| `[d` / `]d`  | Next/prev diagnostic |

### Python

| Key         | Action                |
| ----------- | --------------------- |
| `<Leader>r` | Run file (horizontal) |
| `<Leader>R` | Run file (vertical)   |

### Go

| Key         | Action              |
| ----------- | ------------------- |
| `<Leader>r` | Run file            |
| `<Leader>t` | Run tests           |
| `<Leader>a` | Alternate test/impl |

## Edit Config

| Task     | File                           |
| -------- | ------------------------------ |
| Options  | `config/options.lua`           |
| Keys     | `config/keymaps.lua`           |
| Plugin   | `plugins/init.lua`             |
| Language | `plugins/languages/<lang>.lua` |

## Troubleshooting

| Problem             | Solution                     |
| ------------------- | ---------------------------- |
| Plugins not loading | `make clean && make install` |
| LSP not working     | `:Mason` then `:LspInfo`     |
| Syntax off          | `:TSUpdate`                  |

## What's Included

**LSP**: Python (pyright, ruff), Go (gopls), JS/TS (ts_ls, eslint), C (clangd), Clojure (clojure_lsp)

**Tools**: Telescope, NERDTree, Treesitter, conform.nvim, Neotest, Trouble, Mason

## License

Personal config. Use freely.
