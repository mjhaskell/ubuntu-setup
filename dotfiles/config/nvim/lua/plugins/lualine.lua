-- see https://github.com/nvim-lualine/lualine.nvim

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    {
      "linux-cultist/venv-selector.nvim",
      -- dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
      opts = {
        -- -- Your options go here
        -- -- name = "venv",
        -- -- auto_refresh = false
        -- path = vim.env.HOME .. "/.pyvenvs/",
        ft = "python",
        search = {
          my_venvs = {
            -- command = "fd /bin/python$ ~/.pyvenvs --full-path", -- some systems may use `fd` instead of `fdfind`
            command = "fdfind /bin/python$ ~/.pyvenvs --full-path", -- my system requires `fdfind`
            on_telescope_result_callback = function(selected_venv)
              if selected_venv and #selected_venv > 0 then
                local version = vim.fn.system(selected_venv .. " --version"):gsub("Python ", ""):gsub("%s+", "")
                vim.g.venv_version = version
                return selected_venv:gsub("/bin/python$", ""):gsub(vim.env.HOME .. "/.pyvenvs/", "")
                --   .. " ("
                --   .. version
                --   .. ")"
              end
              return nil
            end,
          },
        },
        options = {
          statusline_func = {
            lualine = function()
              local venv_path = require("venv-selector").venv()
              if not venv_path or venv_path == "" then
                return ""
              end

              -- This seems to cause nvim to flicker when python files are opened, it must be slow
              -- local version = vim.fn.system(venv_path .. "/bin/python --version"):gsub("Python ", ""):gsub("%s+", "")
              if not vim.g.venv_version then
                local version = vim.fn.system(venv_path .. "/bin/python --version"):gsub("Python ", ""):gsub("%s+", "")
                vim.g.venv_version = version
              end

              local venv_name = vim.fn.fnamemodify(venv_path, ":t")
              if not venv_name then
                return ""
              end

              if not vim.g.venv_version or vim.g.venv_version == "" then
                return "🐍 " .. venv_name
              end

              local output = "🐍 " .. venv_name .. " (" .. vim.g.venv_version .. ")"
              return output
            end,
          },
        },
      },
      -- event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
      keys = {
        -- Keymap to open VenvSelector to pick a venv.
        { "<leader>vs", "<cmd>VenvSelect<cr>" },
        -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
        { "<leader>vc", "<cmd>VenvSelectCached<cr>" },
      },
    },
  },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- to configure lazy pending updates count

    local colors = {
      blue = "#65D1FF",
      green = "#3EFFDC",
      violet = "#FF61EF",
      yellow = "#FFDA7B",
      red = "#FF4A4A",
      fg = "#c3ccdc",
      bg = "#112638",
      inactive_bg = "#2c3043",
    }

    local my_lualine_theme = {
      normal = {
        a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      insert = {
        a = { bg = colors.green, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      visual = {
        a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      command = {
        a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      replace = {
        a = { bg = colors.red, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      inactive = {
        a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
        b = { bg = colors.inactive_bg, fg = colors.semilightgray },
        c = { bg = colors.inactive_bg, fg = colors.semilightgray },
      },
    }

    -- configure lualine with modified theme
    lualine.setup({
      -- see :help lualine

      options = {
        icons_enabled = true,
        theme = my_lualine_theme,
        component_separators = { left = " ", right = " " },
        section_separators = { left = "", right = "" },
        --section_separators = { left = '', right = '' },
        --component_separators = { left = '', right = '' }
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = true,
        refresh = {
          statusline = 100,
          tabline = 100,
          winbar = 100,
        },
      },

      sections = {
        ----------------------------------------------------------------------------------
        -- sections: | A | B | C                         X | Y | Z |

        -- Available lualine components:
        -- `branch` (git branch)
        -- `buffers` (shows currently available buffers)
        -- `diagnostics` (diagnostics count from your preferred source)
        -- `diff` (git diff status)
        -- `encoding` (file encoding)
        -- `fileformat` (file format)
        -- `filename`
        -- `filesize`
        -- `filetype`
        -- `hostname`
        -- `location` (location in file in line:column format)
        -- `mode` (vim mode)
        -- `progress` (%progress in file)
        -- `searchcount` (number of search matches when hlsearch is active)
        -- `selectioncount` (number of selected characters or lines)
        -- `tabs` (shows currently available tabs)
        -- `windows` (shows currently available windows)
        -- `lsp_status` (shows active LSPs in the current buffer and a progress spinner)
        ----------------------------------------------------------------------------------

        -- lualine_a = { "mode" },
        lualine_a = {
          {
            "windows",
            windows_color = {
              active = "lualine_a_normal",
              inactive = "lualine_a_inactive",
            },
          },
        },
        -- lualine_b = { "branch", "diff", "diagnostics" },
        lualine_b = {
          "branch",
          "diff",
        },
        -- lualine_c = { "filename" },
        lualine_c = {},
        -- lualine_c = {
        --   {
        --     "windows",
        --     windows_color = {
        --       active = "lualine_a_normal",
        --       inactive = "lualine_a_inactive",
        --     },
        --   },
        -- },
        -- lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { "encoding" },
          { "fileformat" },
          { "lsp_status" },
          {
            "venv-selector",
            -- cond = function()
            --   return vim.bo.filetype == "python"
            -- end,
            on_click = function()
              vim.cmd("VenvSelect")
            end,
          },
          -- { "filetype" },
        },
        -- lualine_y = { "progress", "filesize", "location" },
        lualine_y = { "progress", "location" },
        lualine_z = { "mode" },
        -- lualine_z = { "branch", "mode" },
      },

      inactive_sections = {
        -- lualine_a = {},
        -- lualine_b = {},
        -- lualine_c = { "filename" },
        -- lualine_x = { "location" },
        -- lualine_y = {},
        -- lualine_z = {},
      },

      tabline = {
        -- I think I like bufferline tabs better
        -- lualine_a = {
        --   {
        --     "tabs",
        --     mode = 2,
        --     path = 0,
        --     max_length = vim.o.columns * 2 / 3,
        --     tabs_color = {
        --       active = "lualine_a_normal", --colors.blue,
        --       inactive = "lualine_a_inactive", --colors.red,
        --     },
        --   },
        -- },
        -- lualine_z = { "windows" },
      },

      winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
        -- cond = function()
        --   return false
        -- end,
        -- lualine_a = { "windows" },
        -- lualine_c = {
        --   {
        --     "filename",
        --     file_status = true,
        --     symbols = {
        --       modified = "[+]",
        --       readonly = "[Read Only]",
        --       unnamed = "[No Name]",
        --       newfile = "[New]",
        --     },
        --   },
        -- },
        -- lualine_x = { "diff", "location" },
        -- lualine_z = { "filename" },
      },

      inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
        -- cond = function()
        --   return false
        -- end,
        -- lualine_a = { "windows" },
        -- lualine_c = {
        --   {
        --     "filename",
        --     file_status = true,
        --     symbols = {
        --       modified = "[+]",
        --       readonly = "[Read Only]",
        --       unnamed = "[No Name]",
        --       newfile = "[New]",
        --     },
        --   },
        -- },
        -- lualine_x = { "diff", "location" },
        -- lualine_z = { "filename" },
      },

      extensions = {},
    })
  end,
}
