return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      -- {  -- more modern lua implementation of copilot
      --   "zbirenbaum/copilot-cmp",
      --   config = function()
      --     require("copilot_cmp").setup()
      --   end,
      --   dependencies = {
      --     "zbirenbaum/copilot.lua",
      --     "hrsh7th/nvim-cmp", -- Requires nvim-cmp
      --   },
      -- },
      { -- official copilot plugin
        "github/copilot.vim",
        config = function()
          vim.g.copilot_filetypes = {
            -- ["markdown"] = true,
            -- ["text"] = true,
            -- ["python"] = true,
            -- ["lua"] = true,
            -- ["javascript"] = true,
            -- ["typescript"] = true,
            -- ["rust"] = true,
            -- ["go"] = true,
            -- ["java"] = true,
            -- ["c"] = true,
            -- ["cpp"] = true,
            -- ["html"] = true,
            -- ["css"] = true,
            -- ["json"] = true,
            -- ["yaml"] = true,
            -- ["sh"] = true,
            -- ["zsh"] = true,
            -- ["bash"] = true,
            ["*"] = true,
          }

          -- disable tab completion - use alt-tab instead
          vim.g.copilot_no_tab_map = true
          vim.keymap.set("i", "<M-Tab>", 'copilot#Accept("\\<CR>")', {
            expr = true,
            replace_keycodes = false,
          })
          -- vim.keymap.set("n", "<leader>cc", "<CMD>CopilotChatToggle<CR>", { desc = "Toggle Copilot Chat" })
          -- vim.keymap.set("v", "<leader>ce", "<CMD>CopilotChatExplain<CR>", { desc = "Explain with Copilot Chat" })
          -- vim.keymap.set("v", "<leader>cf", "<CMD>CopilotChatFix<CR>", { desc = "Fix with Copilot Chat" })
          -- vim.keymap.set("v", "<leader>co", "<CMD>CopilotChatOptimize<CR>", { desc = "Optimize with Copilot Chat" })
        end,
      },
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {
      -- See Configuration section for options
      -- model = "gpt-4.1",
      model = "auto",
      models = { -- temporary fix while models from "auto" don't work
        ["gpt-5.4-mini"] = {
          provider = "copilot",
          name = "gpt-5.4-mini",
        },
        ["gpt-5-mini"] = {
          provider = "copilot",
          name = "gpt-5-mini",
        },
      },
      -- window = {
      --   layout = "float", -- "float", "vertical", "horizontal"
      --   width = 0.5,
      --   height = 0.7,
      --   -- width = 80,
      --   -- height = 20,
      --   title = "🤖  Copilot Chat",
      --   zindex = 100, -- ensure window stays on top
      -- },
      headers = {
        user = "👤 You",
        assistant = "🤖 Copilot",
        tool = "🛠️  Tool",
      },
      -- separator = "━━",
      -- auto_fold = true, -- auto fold non-assistant messages
    },
    keys = {
      { "<leader>a", mode = { "n", "x", "o" }, "", desc = "AI" },
      {
        "<leader>aa",
        mode = { "n", "x", "o" },
        function()
          local chat = require("CopilotChat")
          chat.toggle({ window = { layout = "float" } })
        end,
        desc = "Toggle Copilot Float",
      },
      {
        "<leader>av",
        mode = { "n", "x", "o" },
        function()
          local chat = require("CopilotChat")
          chat.toggle({ window = { layout = "vertical", width = 80 } })
        end,
        desc = "Toggle Copilot Vertical",
      },
      {
        "<leader>ah",
        mode = { "n", "x", "o" },
        function()
          local chat = require("CopilotChat")
          chat.toggle({ window = { layout = "horizontal", height = 0.25 } })
        end,
        desc = "Toggle Copilot Horizontal",
      },
      {
        "<leader>ae",
        mode = { "v" },
        "<CMD>CopilotChatExplain<CR>",
        desc = "Explain with Copilot Chat",
      },
      {
        "<leader>af",
        mode = { "v" },
        "<CMD>CopilotChatFix<CR>",
        desc = "Fix with Copilot Chat",
      },
      {
        "<leader>ao",
        mode = { "v" },
        "<CMD>CopilotChatOptimize<CR>",
        desc = "Optimize with Copilot Chat",
      },
    },
  },
}
