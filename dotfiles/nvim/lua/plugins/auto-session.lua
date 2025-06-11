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
    { "<leader>w", "", desc = "Sessions" },
    { "<leader>wf", "<cmd>SessionSearch<CR>", desc = "Find and load session" },
    { "<leader>wr", "<cmd>SessionRestore<CR>", desc = "Restore session" },
    { "<leader>ws", "<cmd>SessionSave<CR>", desc = "Save session" },
    { "<leader>wa", "<cmd>SessionToggleAutoSave<CR>", desc = "Toggle autosave" },
    -- TODO: write custom funtion that populates a telescope picker of sessions to save
    { "<leader>wS", ":SessionSave ", desc = "Save named session" },
  },
}
