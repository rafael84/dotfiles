.PHONY: help install update clean link unlink check-deps install-deps

NVIM_CONFIG_DIR := $(HOME)/.config/nvim
DOTFILES_DIR := $(shell pwd)
VIM_DIR := $(DOTFILES_DIR)/vim

help:
	@echo "Vim Dotfiles Manager"
	@echo ""
	@echo "Usage:"
	@echo "  make install      - Full setup (deps + link + plugins)"
	@echo "  make update       - Update plugins and dependencies"
	@echo "  make clean        - Remove plugins"
	@echo "  make link         - Create symlinks"
	@echo "  make unlink       - Remove symlinks"
	@echo "  make check-deps   - Check installed dependencies"
	@echo "  make install-deps - Install/upgrade dependencies"

check-deps:
	@echo "Checking dependencies..."
	@command -v brew >/dev/null 2>&1 || { echo "Error: Homebrew not installed"; exit 1; }
	@command -v nvim >/dev/null 2>&1 && echo "✓ neovim" || echo "✗ neovim"
	@command -v git >/dev/null 2>&1 && echo "✓ git" || echo "✗ git"
	@command -v rg >/dev/null 2>&1 && echo "✓ ripgrep" || echo "✗ ripgrep"
	@command -v fd >/dev/null 2>&1 && echo "✓ fd" || echo "✗ fd"
	@command -v node >/dev/null 2>&1 && echo "✓ node" || echo "✗ node"

install-deps:
	@echo "Installing/upgrading dependencies..."
	@brew install neovim
	@brew install git
	@brew install ripgrep
	@brew install fd
	@brew install node
	@echo "✓ All dependencies installed"

link:
	@echo "Creating symlinks..."
	@mkdir -p $(NVIM_CONFIG_DIR)
	@if [ -e $(NVIM_CONFIG_DIR)/init.vim ]; then \
		echo "Backing up old init.vim to init.vim.old"; \
		mv $(NVIM_CONFIG_DIR)/init.vim $(NVIM_CONFIG_DIR)/init.vim.old; \
	fi
	@if [ -e $(NVIM_CONFIG_DIR)/init.lua ] && [ ! -L $(NVIM_CONFIG_DIR)/init.lua ]; then \
		echo "Backing up existing init.lua to init.lua.backup"; \
		mv $(NVIM_CONFIG_DIR)/init.lua $(NVIM_CONFIG_DIR)/init.lua.backup; \
	fi
	@if [ -d $(NVIM_CONFIG_DIR)/lua ] && [ ! -L $(NVIM_CONFIG_DIR)/lua ]; then \
		echo "Backing up existing lua/ to lua.backup"; \
		mv $(NVIM_CONFIG_DIR)/lua $(NVIM_CONFIG_DIR)/lua.backup; \
	fi
	@ln -sf $(VIM_DIR)/init.lua $(NVIM_CONFIG_DIR)/init.lua
	@ln -sf $(VIM_DIR)/lua $(NVIM_CONFIG_DIR)/lua
	@echo "✓ Symlinks created"

unlink:
	@echo "Removing symlinks..."
	@rm -f $(NVIM_CONFIG_DIR)/init.lua
	@rm -f $(NVIM_CONFIG_DIR)/lua
	@echo "✓ Symlinks removed"

install: check-deps install-deps link
	@echo "Installing vim-plug..."
	@sh -c 'curl -fLo "$(HOME)/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' 2>/dev/null || echo "vim-plug already installed"
	@echo "Installing plugins..."
	@nvim --headless +PlugInstall +qall 2>/dev/null || true
	@echo ""
	@echo "✓ Installation complete!"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Run 'nvim' to start neovim"
	@echo "  2. Run ':checkhealth' to verify setup"

update:
	@echo "Updating plugins..."
	@nvim --headless +PlugUpdate +qall 2>/dev/null || true
	@echo "Updating dependencies..."
	@brew upgrade neovim ripgrep fd node 2>/dev/null || true
	@echo "✓ Update complete"

clean:
	@echo "Removing plugins..."
	@nvim --headless +PlugClean! +qall 2>/dev/null || true
	@rm -rf $(HOME)/.local/share/nvim/plugged
	@echo "✓ Plugins removed"
