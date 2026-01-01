-- ============================================================================
-- Clojure Language Configuration
-- ============================================================================

local ok, lspconfig = pcall(require, 'lspconfig')
if not ok then
  return
end

-- Check if LSP globals are set
if not _G.lsp_on_attach or not _G.lsp_capabilities then
  return
end

-- ============================================================================
-- Clojure LSP
-- ============================================================================

pcall(function()
  lspconfig.clojure_lsp.setup({
    on_attach = _G.lsp_on_attach,
    capabilities = _G.lsp_capabilities,
  })
end)

-- ============================================================================
-- vim-fireplace - Clojure REPL Integration
-- ============================================================================
-- Keymaps are defined in config/keymaps.lua

-- ============================================================================
-- Conjure - Modern Clojure REPL
-- ============================================================================

-- Disable gd (use LSP or Fireplace)
vim.g['conjure#mapping#def_word'] = false

-- Disable K (use LSP)
vim.g['conjure#mapping#doc_word'] = false

-- Disable HUD
vim.g['conjure#log#hud#enabled'] = false

-- ============================================================================
-- Bash/Shell LSP
-- ============================================================================

pcall(function()
  lspconfig.bashls.setup({
    on_attach = _G.lsp_on_attach,
    capabilities = _G.lsp_capabilities,
    filetypes = { 'sh', 'bash', 'zsh' },
    settings = {
      bashIde = {
        globPattern = '*@(.sh|.inc|.bash|.command|.zsh)'
      }
    }
  })
end)
