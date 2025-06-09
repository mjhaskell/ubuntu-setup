-- see https://github.com/nvim-lualine/lualine.nvim

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
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
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        --section_separators = { left = '', right = '' },
        --component_separators = { left = '', right = '' }
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
          statusline = 100,
          tabline = 100,
          winbar = 100,
        }
      },

      sections = {
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
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          --{ "encoding" },
          --{ "fileformat" },
          { "filetype" },
        },
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },

      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      },

      tabline = {
        -- I think I like bufferline tabs better
        --lualine_z = {
        --  {
        --    'tabs',
        --    mode = 2,
        --    path = 0,
        --    tabs_color = {
        --      active = 'lualine_a_normal', --colors.blue,
        --      inactive = 'lualine_a_inactive', --colors.red,
        --    },
        --  }
        --}
      },

      winbar = {},

      inactive_winbar = {},

      extensions = {}

    })
  end,
}
