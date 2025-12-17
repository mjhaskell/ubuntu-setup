-- see https://github.com/akinsho/bufferline.nvim

return {
  "akinsho/bufferline.nvim",

  dependencies = { "nvim-tree/nvim-web-devicons" },

  version = "*",

  opts = {
    options = {
      mode = "tabs",
      separator_style = "slant",
    },
  },

  config = function(_, opts)
    require("bufferline").setup(opts)
    local km = vim.keymap
    km.set("n", "<leader>tp", "<cmd>BufferLinePick<CR>", { desc = "Pick a tab" })
  end,

  -- this works, but it causes a collision with my <leader>sm keymap with something called "Marks" from somewhere unknown
  -- keys = {
  --   { "<leader>tp", "<cmd>BufferLinePick<CR>", desc = "Visual selection or word", mode = { "n" } },
  -- },
}
