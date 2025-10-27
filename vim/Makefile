.SUFFIXES:

VIM_DIR  := $(HOME)/.vim
VIMRC    := $(HOME)/.vimrc
AUTOLOAD := $(VIM_DIR)/autoload
PLUGGED  := $(VIM_DIR)/plugged
VIM_PLUG := $(AUTOLOAD)/plug.vim

BASE := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
SRC  := $(BASE)/src

NVIM_DIR  := $(HOME)/.config/nvim
NVIM_INIT := $(NVIM_DIR)/init.vim

# Check for Neovim
NVIM := $(shell command -v nvim 2> /dev/null)
ifndef NVIM
define MSG
Neovim is required but not found.
Please install Neovim 0.9.0 or later:

	brew install neovim

Or visit: https://neovim.io

endef
$(error $(MSG))
endif


.PHONY: install
install: basic
	@echo set runtimepath+="$(VIM_DIR)" > "$(VIMRC)"
	@cat $(SRC)/basic.vim >> "$(VIMRC)"
	@cat $(SRC)/basic-*.vim >> "$(VIMRC)"
	@echo "call plug#begin('$(PLUGGED)')" >> "$(VIMRC)"
	@cat $(SRC)/plug.vim >> "$(VIMRC)"
	@echo 'call plug#end()' >> "$(VIMRC)"
	@cat $(SRC)/plug-*.vim >> "$(VIMRC)"
	@cat $(SRC)/lsp-*.vim >> "$(VIMRC)"
	@cat $(SRC)/theme-*.vim >> "$(VIMRC)"
	@cat $(SRC)/local.vim >> "$(VIMRC)"

.PHONY: basic
basic: basic-vimrc vim-plug plugins | $(VIM_DIR)

.PHONY: basic-vimrc
basic-vimrc:
	@echo set runtimepath+="$(VIM_DIR)" > "$(VIMRC)"
	@cat $(SRC)/basic.vim >> "$(VIMRC)"
	@cat $(SRC)/basic-*.vim >> "$(VIMRC)"
	@echo "call plug#begin('$(PLUGGED)')" >> "$(VIMRC)"
	@cat $(SRC)/plug.vim >> "$(VIMRC)"
	@echo 'call plug#end()' >> "$(VIMRC)"

.PHONY: vim-plug
vim-plug:
	@if [ ! -f $(VIM_PLUG) ]; then \
		echo "Downloading vim-plug..."; \
		mkdir -p $(AUTOLOAD); \
		curl -fLo $(VIM_PLUG) \
			https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; \
	fi
	@mkdir -p $(PLUGGED)

.PHONY: plugins
plugins:
	@mkdir -p $(NVIM_DIR)
	@echo "let vimrc=expand(\"$(VIMRC)\")" > "$(NVIM_INIT)"
	@echo 'if filereadable(vimrc)' >> $(NVIM_INIT)
	@echo '     exec ":source " . vimrc' >> $(NVIM_INIT)
	@echo 'endif' >> $(NVIM_INIT)
	@echo "Installing Neovim plugins..."
	@$(NVIM) +PlugClean! +PlugInstall +qall
	@echo "Plugins installed successfully!"
	@echo ""
	@echo "LSP servers will be installed automatically when you first open a file."
	@echo "To manually install LSP servers, run: make mason-install"

$(VIM_DIR):
	@mkdir -p $(VIM_DIR)

.PHONY: clean
clean:
	@rm -rf $(VIM_DIR) $(VIMRC) $(NVIM_INIT)

.PHONY: plug-update
plug-update:
	@$(NVIM) +PlugUpdate +qall

.PHONY: mason-update
mason-update:
	@$(NVIM) +MasonUpdate +qall

.PHONY: mason-install
mason-install:
	@echo "Installing LSP servers via Mason..."
	@$(NVIM) --headless -c "lua require('mason.api.command').MasonInstall({ 'pyright', 'ruff', 'typescript-language-server', 'eslint-lsp', 'bash-language-server', 'shellcheck', 'shfmt', 'prettier', 'json-lsp', 'html-lsp', 'css-lsp' })" -c "qa"
	@echo "LSP servers installed!"

.PHONY: deps
deps:
	@echo "Installing system dependencies..."
	@brew install neovim ripgrep fd clj-kondo
	@echo "For Python development with uv:"
	@echo "  brew install uv"
	@echo "For Node.js development:"
	@echo "  brew install node"
