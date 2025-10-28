"------------------------------------------------------------------------------
" which-key.nvim - Show keybindings as you type
"------------------------------------------------------------------------------

lua << EOF
local wk = require("which-key")

wk.setup({
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 20,
    },
    presets = {
      operators = true,
      motions = true,
      text_objects = true,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },
  icons = {
    breadcrumb = "»",
    separator = "➜",
    group = "+",
  },
  win = {
    border = "rounded",
    padding = { 1, 2, 1, 2 },
  },
  show_help = true,
  show_keys = true,
  -- Trigger which-key automatically when pressing leader
  triggers = {
    { "<leader>", mode = "n" },
    { "<leader>", mode = "v" },
  },
  -- Delay before showing which-key popup (in milliseconds)
  delay = 500,
})

-- Register leader key mappings with descriptions
wk.add({
  -- File operations
  { "<leader>f", group = "File/Find" },
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
  { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
  { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
  { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
  { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
  { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
  { "<leader>fw", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace symbols" },
  { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
  { "<leader>fm", "<cmd>Format<cr>", desc = "Format buffer" },

  -- LSP
  { "<leader>r", group = "Refactor" },
  { "<leader>rn", vim.lsp.buf.rename, desc = "Rename symbol" },

  { "<leader>c", group = "Code" },
  { "<leader>ca", vim.lsp.buf.code_action, desc = "Code action" },

  -- Diagnostics/Trouble
  { "<leader>x", group = "Diagnostics" },
  { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Toggle diagnostics" },
  { "<leader>xw", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
  { "<leader>xq", "<cmd>Trouble quickfix toggle<cr>", desc = "Quickfix list" },
  { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
  { "<leader>xr", "<cmd>Trouble lsp_references toggle<cr>", desc = "LSP references" },

  { "<leader>e", vim.diagnostic.open_float, desc = "Show diagnostic" },
  { "<leader>q", vim.diagnostic.setloclist, desc = "Diagnostics to loclist" },

  -- Go-specific (shown only in Go files)
  { "<leader>g", group = "Go", mode = "n", cond = function() return vim.bo.filetype == "go" end },
  { "<leader>gt", desc = "Go to type definition", cond = function() return vim.bo.filetype == "go" end },
  { "<leader>gi", desc = "Go to implementation", cond = function() return vim.bo.filetype == "go" end },
  { "<leader>gc", desc = "Go callees", cond = function() return vim.bo.filetype == "go" end },
  { "<leader>gC", desc = "Go callers", cond = function() return vim.bo.filetype == "go" end },
  { "<leader>gd", desc = "Go describe", cond = function() return vim.bo.filetype == "go" end },
  { "<leader>ge", desc = "Go if err", cond = function() return vim.bo.filetype == "go" end },
  { "<leader>gf", desc = "Go fill struct", cond = function() return vim.bo.filetype == "go" end },

  -- Testing
  { "<leader>t", group = "Test" },
  { "<leader>tn", function() require('neotest').run.run() end, desc = "Run nearest test" },
  { "<leader>tf", function() require('neotest').run.run(vim.fn.expand('%')) end, desc = "Run test file" },
  { "<leader>td", function() require('neotest').run.run({strategy = 'dap'}) end, desc = "Debug test" },
  { "<leader>ts", function() require('neotest').run.stop() end, desc = "Stop test" },
  { "<leader>ta", function() require('neotest').run.attach() end, desc = "Attach to test" },
  { "<leader>to", function() require('neotest').output.open({ enter = true }) end, desc = "Show output" },
  { "<leader>tO", function() require('neotest').output_panel.toggle() end, desc = "Toggle output panel" },
  { "<leader>tt", function() require('neotest').summary.toggle() end, desc = "Toggle summary" },
  { "<leader>tc", function()
      local ft = vim.bo.filetype
      local extra_args = {}
      if ft == "python" then
        extra_args = {"--cov"}
      elseif ft == "go" then
        extra_args = {"-cover"}
      elseif ft == "javascript" or ft == "typescript" or ft == "javascriptreact" or ft == "typescriptreact" then
        extra_args = {"--coverage"}
      end
      require('neotest').run.run({extra_args = extra_args})
    end, desc = "Run with coverage" },
  { "<leader>tm", function()
      if vim.bo.filetype == "python" then
        local mark = vim.fn.input("Mark: ")
        require('neotest').run.run({vim.fn.expand("%"), extra_args = {"-m", mark}})
      end
    end, desc = "Run with marks (Python)" },
  { "<leader>tb", function()
      if vim.bo.filetype == "go" then
        require('neotest').run.run({extra_args = {"-bench", "."}})
      end
    end, desc = "Run benchmarks (Go)" },
  { "<leader>tw", function()
      local ft = vim.bo.filetype
      if ft == "javascript" or ft == "typescript" or ft == "javascriptreact" or ft == "typescriptreact" then
        require('neotest').run.run({extra_args = {"--watch"}})
      end
    end, desc = "Run in watch mode (JS/TS)" },

  -- General leader mappings
  { "<leader>a", desc = "Alternate file" },
  { "<leader>b", desc = "Build" },
  { "<leader>r", desc = "Run" },
})

-- Register g mappings (go to)
wk.add({
  { "g", group = "Go to" },
  { "gd", vim.lsp.buf.definition, desc = "Go to definition" },
  { "gD", vim.lsp.buf.declaration, desc = "Go to declaration" },
  { "gi", vim.lsp.buf.implementation, desc = "Go to implementation" },
  { "gr", vim.lsp.buf.references, desc = "Show references" },
  { "gtd", vim.lsp.buf.type_definition, desc = "Type definition" },
})

-- Register [ and ] mappings (navigation)
wk.add({
  { "[", group = "Previous" },
  { "[d", vim.diagnostic.goto_prev, desc = "Previous diagnostic" },
  { "[m", desc = "Previous function" },
  { "[[", desc = "Previous class" },
  { "[t", function() require('neotest').jump.prev({ status = 'failed' }) end, desc = "Previous failed test" },

  { "]", group = "Next" },
  { "]d", vim.diagnostic.goto_next, desc = "Next diagnostic" },
  { "]m", desc = "Next function" },
  { "]]", desc = "Next class" },
  { "]t", function() require('neotest').jump.next({ status = 'failed' }) end, desc = "Next failed test" },
})

EOF
