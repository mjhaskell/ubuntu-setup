return {
  "lukas-reineke/indent-blankline.nvim",

  dependencies = {
    {
      "HiPhish/rainbow-delimiters.nvim"
    },
  },

  event = { "BufReadPre", "BufNewFile" },

  main = "ibl",
  ---@module "ibl"
  ---@type ibl.config

  opts = {
  },

  config = function()
    local highlight = {
      "RainbowRed",
      "RainbowYellow",
      "RainbowBlue",
      "RainbowOrange",
      "RainbowGreen",
      "RainbowViolet",
      "RainbowCyan",
    }
    local bg_highlight = {
      "CursorColumn",
      "Whitespace",
    }

    local hooks = require("ibl.hooks")
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
      vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
      vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
      vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
      vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
      vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
      vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
    end)

    local ibl = require("ibl")

    ---- DEFAULT SETTINGS WITH NO COLORS ON INDENT LINES
    ibl.setup()

    ---- NO COLORS ON INDENT LINES AND NO SCOPE
    --ibl.setup({
    --  scope = { enabled = false },
    --})

    ---- FOR COLORED INDENTS WITH PARTIALLY ACCRATE SCOPE
    --ibl.setup({
    --  indent = {
    --    highlight = highlight
    --  },
    --  scope = {
    --    enabled = true,
    --    --highlight = "IblScope",
    --    --highlight = highlight,
    --  }
    --})

    ---- FOR COLORED INDENTS WITH NO SCOPE
    --ibl.setup({
    --  indent = { highlight = highlight },
    --  scope = { enabled = false, }
    --})

    ---- FOR BACKGROUND HIGHLIGHTED INDENT LINES 
    --ibl.setup({
    --  indent = { highlight = bg_highlight, char = "" },
    --  whitespace = {
    --    highlight = bg_highlight,
    --    remove_blankline_trail = false,
    --  },
    --  scope = { enabled = false },
    --})

    vim.g.rainbow_delimiters = { highlight = highlight }
    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

  end,
}
