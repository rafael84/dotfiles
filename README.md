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

| Key         | Action            |
| ----------- | ----------------- |
| `<Leader>r` | Run file          |
| `<Leader>R` | Run with debugger |

### Go

| Key         | Action              |
| ----------- | ------------------- |
| `<Leader>r` | Run file            |
| `<Leader>t` | Run tests           |
| `<Leader>a` | Alternate test/impl |

### C

| Key          | Action                     |
| ------------ | -------------------------- |
| `<Leader>b`  | Build (uses Makefile)      |
| `<Leader>r`  | Build and run              |
| `<Leader>bs` | Select make target         |
| `<Leader>rs` | Set binary path            |
| `<Leader>a`  | Switch source/header       |
| `<Leader>cF` | Generate .clang-format     |
| `<Leader>cf` | Generate compile_flags.txt |

See [Project-Local Configuration](#project-local-configuration) below for multi-target setups and runtime arguments.

## Project-Local Configuration

Create `.nvim.lua` in any project directory to override settings per-project or per-subdirectory.

**Example: Multi-target C project**

```
my-project/
├── .nvim.lua           # Default: tests
├── Makefile
├── tests/
│   ├── .nvim.lua      # Overrides for tests
│   └── test.c
└── asm/
    ├── .nvim.lua      # Overrides for assembler
    └── assembler.c
```

```lua
-- tests/.nvim.lua
vim.g.c_make_target = 'tests'
vim.g.c_binary_path = 'bin/app-tests'
vim.g.c_binary_args = '--verbose'  -- Args passed to binary when running with <leader>r

-- asm/.nvim.lua
vim.g.c_make_target = 'assembler'
vim.g.c_binary_path = 'bin/assembler'
vim.g.c_binary_args = 'input.txt output.txt'  -- Example: pass files as args
```

Config automatically reloads when switching between files in different directories.

**Commands:**

- `:ProjectConfigShow` - Show current settings
- `:ProjectConfigReload` - Manually reload config

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
