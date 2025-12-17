--see https://github.com/nvim-neo-tree/neo-tree.nvim?tab=readme-ov-file#quickstart

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
    {
      "s1n7ax/nvim-window-picker", -- for open_with_window_picker keymaps
      version = "2.*",
      config = function()
        require("window-picker").setup({
          filter_rules = {
            include_current_win = false,
            autoselect_one = true,
            -- filter using buffer options
            bo = {
              -- if the file type is one of following, the window will be ignored
              filetype = { "neo-tree", "neo-tree-popup", "notify" },
              -- if the buffer type is one of following, the window will be ignored
              buftype = { "terminal", "quickfix" },
            },
          },
        })
      end,
    },
  },

  lazy = false, -- neo-tree will lazily load itself
  ---@module "neo-tree"
  ---@type neotree.Config?

  opts = {
    -- fill any relevant options here
    window = {
      position = "float",
      width = 30,
    },

    filesystem = {
      filtered_items = {
        hide_dotfiles = true,
        hide_gitignored = true,
        hide_hidden = true, -- for Windows hidden files
        hide_by_name = {
          --"node_modules"
        },
        hide_by_pattern = { -- uses glob style patterns
          --"*.meta",
          --"*/src/*/tsconfig.json",
        },
        always_show = { -- remains visible even if other settings would normally hide it
          --".gitignored",
        },
        always_show_by_pattern = { -- uses glob style patterns
          --".env*",
        },
        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
          --".DS_Store",
          --"thumbs.db"
        },
        never_show_by_pattern = { -- uses glob style patterns
          --".null-ls_*",
        },
      },
    },
  },

  config = function(_, opts)
    require("neo-tree").setup(opts)
    local km = vim.keymap
    km.set("n", "<leader>ee", "<CMD>Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
    km.set("n", "<leader>er", "<CMD>Neotree reveal<CR>", { desc = "Open Neo-tree to current file (reveal)" })
    km.set("n", "<leader>eb", "<CMD>Neotree buffers<CR>", { desc = "Open Neo-tree buffers" })
    km.set("n", "<leader>es", "<CMD>Neotree git_status<CR>", { desc = "Show Neo-tree git status" })
    km.set("n", "<leader>eh", "<CMD>Neotree left<CR>", { desc = "Open Neo-tree on left" })
    km.set("n", "<leader>el", "<CMD>Neotree right<CR>", { desc = "Open Neo-tree on right" })
    km.set("n", "<leader>ef", "<CMD>Neotree float<CR>", { desc = "Open floating Neo-tree" })
  end,
}
