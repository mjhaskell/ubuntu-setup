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
    km.set("n", "<leader>tp", "<cmd>BufferLinePick<CR>", {desc="Pick a tab"})
  end,
}
