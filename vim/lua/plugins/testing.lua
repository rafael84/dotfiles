-- ============================================================================
-- Neotest - Modern Test Runner
-- ============================================================================

require('neotest').setup({
  -- Enable logging for debugging
  log_level = vim.log.levels.DEBUG,

  adapters = {
    -- Python (pytest, unittest)
    require('neotest-python')({
      dap = { justMyCode = false },
      args = { '--log-level', 'DEBUG' },
      runner = 'pytest',
      python = function()
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
    require('neotest-go')({
      experimental = {
        test_table = true,
      },
      args = { '-count=1', '-timeout=60s' }
    }),

    -- JavaScript/TypeScript (Jest)
    require('neotest-jest')({
      jestCommand = 'npm test --',
      jestConfigFile = 'jest.config.js',
      env = { CI = true },
      cwd = function()
        return vim.fn.getcwd()
      end,
    }),

    -- JavaScript/TypeScript (Vitest)
    require('neotest-vitest'),
  },

  -- UI configuration
  icons = {
    running = '⏳',
    passed = '✅',
    failed = '❌',
    skipped = '⏭️',
    unknown = '❓',
  },

  -- Floating window for test output
  floating = {
    border = 'rounded',
    max_height = 0.8,
    max_width = 0.8,
  },

  -- Summary window
  summary = {
    enabled = true,
    expand_errors = true,
    follow = true,
    mappings = {
      attach = 'a',
      expand = { '<CR>', '<2-LeftMouse>' },
      expand_all = 'e',
      jumpto = 'i',
      mark = 'm',
      next_failed = 'J',
      output = 'o',
      prev_failed = 'K',
      run = 'r',
      short = 'O',
      stop = 'u',
      target = 't',
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
    open_on_run = 'short',
  },
})

-- ============================================================================
-- Keybindings (registered in diagnostics.lua with which-key)
-- ============================================================================

local wk = require('which-key')

wk.add({
  -- Testing
  { '<leader>t', group = 'Test' },
  { '<leader>tn', function() require('neotest').run.run() end, desc = 'Run nearest test' },
  { '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end, desc = 'Run test file' },
  { '<leader>td', function() require('neotest').run.run({ strategy = 'dap' }) end, desc = 'Debug test' },
  { '<leader>ts', function() require('neotest').run.stop() end, desc = 'Stop test' },
  { '<leader>ta', function() require('neotest').run.attach() end, desc = 'Attach to test' },
  { '<leader>to', function() require('neotest').output.open({ enter = true }) end, desc = 'Show output' },
  { '<leader>tO', function() require('neotest').output_panel.toggle() end, desc = 'Toggle output panel' },
  { '<leader>tt', function() require('neotest').summary.toggle() end, desc = 'Toggle summary' },
  {
    '<leader>tc',
    function()
      local ft = vim.bo.filetype
      local extra_args = {}
      if ft == 'python' then
        extra_args = { '--cov' }
      elseif ft == 'go' then
        extra_args = { '-cover' }
      elseif ft == 'javascript' or ft == 'typescript' or ft == 'javascriptreact' or ft == 'typescriptreact' then
        extra_args = { '--coverage' }
      end
      require('neotest').run.run({ extra_args = extra_args })
    end,
    desc = 'Run with coverage'
  },
  {
    '<leader>tm',
    function()
      if vim.bo.filetype == 'python' then
        local mark = vim.fn.input('Mark: ')
        require('neotest').run.run({ vim.fn.expand('%'), extra_args = { '-m', mark } })
      end
    end,
    desc = 'Run with marks (Python)'
  },
  {
    '<leader>tb',
    function()
      if vim.bo.filetype == 'go' then
        require('neotest').run.run({ extra_args = { '-bench', '.' } })
      end
    end,
    desc = 'Run benchmarks (Go)'
  },
  {
    '<leader>tw',
    function()
      local ft = vim.bo.filetype
      if ft == 'javascript' or ft == 'typescript' or ft == 'javascriptreact' or ft == 'typescriptreact' then
        require('neotest').run.run({ extra_args = { '--watch' } })
      end
    end,
    desc = 'Run in watch mode (JS/TS)'
  },
})

-- Add test navigation to [ and ]
wk.add({
  { '[t', function() require('neotest').jump.prev({ status = 'failed' }) end, desc = 'Previous failed test' },
  { ']t', function() require('neotest').jump.next({ status = 'failed' }) end, desc = 'Next failed test' },
})
