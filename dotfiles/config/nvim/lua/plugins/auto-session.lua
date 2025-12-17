return {
  "rmagatti/auto-session",
  lazy = false,

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { "~/", "~/tmp", "~/Downloads", "/" },
    auto_save = false,

    ---set directory where sessions are saved
    -- root_dir = vim.fn.stdpath("data") .. "/sessions/", -- default
    -- vim.fn.stdpath('data') is "~/.local/share/nvim"
  },

  setup = function()
    local as = require("auto-session").setup({
      -- don't save save session when in dashboard
      bypass_save_filetypes = { "alpha", "dashboard" },
    })
  end,

  keys = {
    -- Will use Telescope if installed or a vim.ui.select picker otherwise
    { "<leader>S", "", desc = "Sessions" },
    { "<leader>Sf", "<cmd>AutoSession search<CR>", desc = "Find and load session" },
    { "<leader>Sr", "<cmd>AutoSession restore<CR>", desc = "Restore session" },
    { "<leader>Sw", "<cmd>AutoSession save<CR>", desc = "Save session" },
    { "<leader>Sd", "<cmd>AutoSession deletePicker<CR>", desc = "Open picker to delete session" },
    { "<leader>Sa", "<cmd>AutoSession toggle<CR>", desc = "Toggle autosave" },
    -- TODO: write custom funtion that populates a telescope picker of sessions to save
    { "<leader>SW", ":AutoSession save ", desc = "Save named session manually" },
    { "<leader>SD", ":AutoSession delete ", desc = "Delete named session manually" },
  },
}
