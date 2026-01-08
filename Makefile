.PHONY: help install update clean link unlink check-deps install-deps
.PHONY: install-vim install-emacs link-vim link-emacs unlink-vim unlink-emacs
.PHONY: check-deps-vim check-deps-emacs install-deps-vim install-deps-emacs

NVIM_CONFIG_DIR := $(HOME)/.config/nvim
EMACS_CONFIG_DIR := $(HOME)/.emacs.d
DOTFILES_DIR := $(shell pwd)
VIM_DIR := $(DOTFILES_DIR)/vim
EMACS_DIR := $(DOTFILES_DIR)/emacs

help:
	@echo "Dotfiles Manager"
	@echo ""
	@echo "Vim Commands:"
	@echo "  make install-vim      - Full vim setup (deps + link + plugins)"
	@echo "  make link-vim         - Create vim symlinks"
	@echo "  make unlink-vim       - Remove vim symlinks"
	@echo "  make check-deps-vim   - Check vim dependencies"
	@echo "  make install-deps-vim - Install vim dependencies"
	@echo ""
	@echo "Emacs Commands:"
	@echo "  make install-emacs      - Full emacs setup (deps + link)"
	@echo "  make link-emacs         - Create emacs symlinks"
	@echo "  make unlink-emacs       - Remove emacs symlinks"
	@echo "  make check-deps-emacs   - Check emacs dependencies"
	@echo "  make install-deps-emacs - Install emacs dependencies"
	@echo ""
	@echo "Legacy Commands (vim only):"
	@echo "  make install      - Same as install-vim"
	@echo "  make link         - Same as link-vim"
	@echo "  make unlink       - Same as unlink-vim"
	@echo "  make check-deps   - Same as check-deps-vim"
	@echo "  make install-deps - Same as install-deps-vim"

check-deps-vim:
	@echo "Checking vim dependencies..."
	@command -v brew >/dev/null 2>&1 || { echo "Error: Homebrew not installed"; exit 1; }
	@command -v nvim >/dev/null 2>&1 && echo "✓ neovim" || echo "✗ neovim"
	@command -v git >/dev/null 2>&1 && echo "✓ git" || echo "✗ git"
	@command -v rg >/dev/null 2>&1 && echo "✓ ripgrep" || echo "✗ ripgrep"
	@command -v fd >/dev/null 2>&1 && echo "✓ fd" || echo "✗ fd"
	@command -v node >/dev/null 2>&1 && echo "✓ node" || echo "✗ node"
	@command -v shfmt >/dev/null 2>&1 && echo "✓ shfmt" || echo "✗ shfmt"
	@command -v stylua >/dev/null 2>&1 && echo "✓ stylua" || echo "✗ stylua"
	@command -v gofumpt >/dev/null 2>&1 && echo "✓ gofumpt" || echo "✗ gofumpt"
	@command -v clang-format >/dev/null 2>&1 && echo "✓ clang-format" || echo "✗ clang-format"

check-deps-emacs:
	@echo "Checking emacs dependencies..."
	@command -v brew >/dev/null 2>&1 || { echo "Error: Homebrew not installed"; exit 1; }
	@command -v emacs >/dev/null 2>&1 && echo "✓ emacs" || echo "✗ emacs"
	@command -v git >/dev/null 2>&1 && echo "✓ git" || echo "✗ git"
	@command -v clojure-lsp >/dev/null 2>&1 && echo "✓ clojure-lsp" || echo "✗ clojure-lsp"
	@command -v lein >/dev/null 2>&1 && echo "✓ leiningen" || echo "✗ leiningen"
	@command -v clojure >/dev/null 2>&1 && echo "✓ clojure-cli" || echo "✗ clojure-cli"

check-deps: check-deps-vim

install-deps-vim:
	@echo "Installing/upgrading vim dependencies..."
	@brew install neovim
	@brew install git
	@brew install ripgrep
	@brew install fd
	@brew install node
	@brew install shfmt
	@brew install stylua
	@brew install gofumpt
	@brew install clang-format
	@echo "✓ All vim dependencies installed"

install-deps-emacs:
	@echo "Installing/upgrading emacs dependencies..."
	@brew install emacs
	@brew install git
	@brew install clojure-lsp/brew/clojure-lsp-native
	@brew install leiningen
	@brew install clojure/tools/clojure
	@echo "✓ All emacs dependencies installed"

install-deps: install-deps-vim

link-vim:
	@echo "Creating vim symlinks..."
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
	@if [ -e $(HOME)/.clang-format ] && [ ! -L $(HOME)/.clang-format ]; then \
		echo "Backing up existing .clang-format to .clang-format.backup"; \
		mv $(HOME)/.clang-format $(HOME)/.clang-format.backup; \
	fi
	@ln -sf $(DOTFILES_DIR)/.clang-format $(HOME)/.clang-format
	@echo "✓ Vim symlinks created"

link-emacs:
	@echo "Creating emacs symlinks..."
	@if [ -f $(HOME)/.spacemacs ] && [ ! -L $(HOME)/.spacemacs ]; then \
		echo "Backing up existing .spacemacs to .spacemacs.backup-$$(date +%Y%m%d-%H%M%S)"; \
		mv $(HOME)/.spacemacs $(HOME)/.spacemacs.backup-$$(date +%Y%m%d-%H%M%S); \
	fi
	@if [ -d $(EMACS_CONFIG_DIR) ] && [ ! -L $(EMACS_CONFIG_DIR) ]; then \
		echo "Backing up existing .emacs.d to .emacs.d.backup-$$(date +%Y%m%d-%H%M%S)"; \
		mv $(EMACS_CONFIG_DIR) $(EMACS_CONFIG_DIR).backup-$$(date +%Y%m%d-%H%M%S); \
	fi
	@ln -sf $(EMACS_DIR) $(EMACS_CONFIG_DIR)
	@echo "✓ Emacs symlinks created"

unlink-vim:
	@echo "Removing vim symlinks..."
	@rm -f $(NVIM_CONFIG_DIR)/init.lua
	@rm -f $(NVIM_CONFIG_DIR)/lua
	@rm -f $(HOME)/.clang-format
	@echo "✓ Vim symlinks removed"

unlink-emacs:
	@echo "Removing emacs symlinks..."
	@if [ -L $(EMACS_CONFIG_DIR) ]; then \
		rm -f $(EMACS_CONFIG_DIR); \
		echo "✓ Emacs symlinks removed"; \
	else \
		echo "Warning: $(EMACS_CONFIG_DIR) is not a symlink, not removing"; \
	fi

link: link-vim
unlink: unlink-vim

install-vim: check-deps-vim install-deps-vim link-vim
	@echo "Installing vim-plug..."
	@sh -c 'curl -fLo "$(HOME)/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' 2>/dev/null || echo "vim-plug already installed"
	@echo "Installing plugins..."
	@nvim --headless +PlugInstall +qall 2>/dev/null || true
	@echo ""
	@echo "✓ Vim installation complete!"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Run 'nvim' to start neovim"
	@echo "  2. Run ':checkhealth' to verify setup"

install-emacs: check-deps-emacs install-deps-emacs link-emacs
	@echo ""
	@echo "✓ Emacs installation complete!"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Run 'emacs' to start emacs"
	@echo "  2. Wait for packages to install (first launch takes 2-3 minutes)"
	@echo "  3. Restart emacs after package installation completes"
	@echo ""
	@echo "Configuration location: ~/.emacs.d -> $(EMACS_DIR)"

install: install-vim

update:
	@echo "Updating plugins..."
	@nvim --headless +PlugUpdate +qall 2>/dev/null || true
	@echo "Updating dependencies..."
	@brew upgrade neovim ripgrep fd node shfmt stylua gofumpt clang-format 2>/dev/null || true
	@echo "✓ Update complete"

clean:
	@echo "Removing plugins..."
	@nvim --headless +PlugClean! +qall 2>/dev/null || true
	@rm -rf $(HOME)/.local/share/nvim/plugged
	@echo "✓ Plugins removed"
