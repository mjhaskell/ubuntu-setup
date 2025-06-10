return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {},

  keys = {
    { "<leader>d", "", desc = "Debug" },
    { "<leader>b", "", desc = "Buffers" },
    { "<leader>c", "", desc = "Code" },
    { "<leader>e", "", desc = "Explorer" },
    { "<leader>f", "", desc = "Find" },
    { "<leader>g", "", desc = "git" },
    { "<leader>h", "", desc = "hunks" },
    { "<leader>s", "", desc = "Search, Split, Source" },
    { "<leader>t", "", desc = "Tabs" },
    { "<leader>T", "", desc = "Todo" },
    { "<leader>u", "", desc = "UI" },
    { "<leader>v", "", desc = "Vim (edit configs)" },
    { "<leader>x", "", desc = "Diagnostics" },
  },

  -- setup = function()
  --   local wk = require("which-key")
  --
  --   wk.add({
  --     { "<leader>d", group = "Debug and Diagnostics" },
  --     { "<leader>c", group = "code" },
  --     { "<leader>u", group = "ui" },
  --   })
  -- end,
}
