"------------------------------------------------------------------------------
" Mason - LSP/Formatter/Linter Installer
"------------------------------------------------------------------------------

lua << EOF
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require("mason-lspconfig").setup({
    ensure_installed = {
        -- Python
        "pyright",
        "ruff",

        -- JavaScript/TypeScript
        "ts_ls",
        "eslint",

        -- Shell
        "bashls",

        -- Other languages you use
        "gopls",
        "clojure_lsp",
    },
    automatic_installation = true,
})

EOF
