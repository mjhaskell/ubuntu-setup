return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Set header
    dashboard.section.header.val = {
      "                                                     ",
      "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
      "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
      "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
      "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
      "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
      "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
      "                                                     ",
    }

    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button("n", "  > New file", "<cmd>ene<CR>"),
      --dashboard.button("SPC ee", "  > Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
      -- dashboard.button("s", "  > Open session", "<cmd>SessionSearch<CR>"),
      dashboard.button("r", "󰁯  > Restore session", "<cmd>SessionSearch<CR>"),
      dashboard.button("e", "  > Toggle file explorer", "<cmd>Neotree toggle<CR>"),
      dashboard.button("f", "󰱼  > Find file", "<cmd>Telescope find_files<CR>"),
      dashboard.button("g", "󰍉  > Grep", "<cmd>Telescope live_grep<CR>"),
      dashboard.button("c", "  > Find config file", function()
        local builtin = require("telescope.builtin")
        builtin.find_files({
          -- search_dir = { os.getenv("HOME") .. "/.config/nvim" },
          cwd = os.getenv("HOME") .. "/.config/nvim",
        })
      end),
      -- dashboard.button("r", "󰁯  > Restore session for cwd", "<cmd>SessionRestore<CR>"),
      dashboard.button("L", "󰒲  > Open Lazy", "<cmd>Lazy<CR>"),
      dashboard.button("Q", "  > Quit NVIM", "<cmd>qa<CR>"),
    }

    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
  end,
}
