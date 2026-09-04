if true then
  return {}
else
  return {

    -- LazyVim config
    {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      ft = { "markdown" },

      -- -- install without yarn or npm
      -- build = function()
      --   require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      --   vim.fn["mkdp#util#install"]()
      -- end,

      -- -- install with yarn or npm
      build = "cd app && npm install",

      keys = {
        {
          "<leader>cp",
          ft = "markdown",
          "<cmd>MarkdownPreviewToggle<cr>",
          desc = "Markdown Preview",
        },
      },
      config = function()
        vim.g.mkdp_browser = "chromium"
        vim.cmd([[do FileType]])
      end,
    },

    -- {
    --   "mrjones2014/mdpreview.nvim",
    --   ft = "markdown", -- you can lazy load on markdown files only
    --   -- requires the `terminal` filetype to render ASCII color and format codes
    --   dependencies = { "norcalli/nvim-terminal.lua", config = true },
    --   opts = {
    --     cli_args = {
    --       "glow",
    --       -- glow assumes you want no colors if not run in a TTY
    --       "-s",
    --       "dark",
    --       -- let nvim handle word wrapping, disable glow word wrap
    --       "-w",
    --       "1",
    --       -- don't unexpectedly make network connections
    --       -- "--local",
    --     },
    --   },
    -- },
  }
end
