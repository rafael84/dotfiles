"------------------------------------------------------------------------------
" Neotest - Modern Test Runner
"------------------------------------------------------------------------------

lua << EOF
require("neotest").setup({
  -- Enable logging for debugging
  log_level = vim.log.levels.DEBUG,

  adapters = {
    -- Python (pytest, unittest)
    require("neotest-python")({
      dap = { justMyCode = false },
      args = { "--log-level", "DEBUG" },
      runner = "pytest",
      python = function()
        -- Use the same Python detection as LSP
        local cwd = vim.fn.getcwd()
        local uv_venv = cwd .. '/.venv'
        if vim.fn.isdirectory(uv_venv) == 1 then
          return uv_venv .. '/bin/python'
        end
        local venv = cwd .. '/venv'
        if vim.fn.isdirectory(venv) == 1 then
          return venv .. '/bin/python'
        end
        local virtual_env = os.getenv('VIRTUAL_ENV')
        if virtual_env then
          return virtual_env .. '/bin/python'
        end
        return vim.fn.exepath('python3') or vim.fn.exepath('python')
      end,
    }),

    -- Go (go test)
    require("neotest-go")({
      experimental = {
        test_table = true,
      },
      args = { "-count=1", "-timeout=60s" }
    }),

    -- JavaScript/TypeScript (Jest)
    require("neotest-jest")({
      jestCommand = "npm test --",
      jestConfigFile = "jest.config.js",
      env = { CI = true },
      cwd = function()
        return vim.fn.getcwd()
      end,
    }),

    -- JavaScript/TypeScript (Vitest)
    require("neotest-vitest"),
  },

  -- UI configuration
  icons = {
    running = "⏳",
    passed = "✅",
    failed = "❌",
    skipped = "⏭️",
    unknown = "❓",
  },

  -- Floating window for test output
  floating = {
    border = "rounded",
    max_height = 0.8,
    max_width = 0.8,
  },

  -- Summary window
  summary = {
    enabled = true,
    expand_errors = true,
    follow = true,
    mappings = {
      attach = "a",
      expand = { "<CR>", "<2-LeftMouse>" },
      expand_all = "e",
      jumpto = "i",
      mark = "m",
      next_failed = "J",
      output = "o",
      prev_failed = "K",
      run = "r",
      short = "O",
      stop = "u",
      target = "t",
    },
  },

  -- Show status in statusline
  status = {
    enabled = true,
    virtual_text = false,
    signs = true,
  },

  -- Output window
  output = {
    enabled = true,
    open_on_run = "short",
  },
})
EOF

" Note: Test keybindings are configured in plug-which-key.vim
" This keeps all keybinding descriptions in one place for better discoverability
