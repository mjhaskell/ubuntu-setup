return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    -- "nvim-treesitter/nvim-treesitter-textobjects",
    -- "JoosepAlviste/nvim-ts-context-commentstring",
    "windwp/nvim-ts-autotag",
    -- "p00f/nvim-ts-rainbow",
  },
  config = function()
    local treesitter = require("nvim-treesitter.configs")

    treesitter.setup({

      highlight = {
        enable = true,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },

      indent = {
        enable = true,
        -- disable = { "yaml" },
      },

      --autopairs = {
      --  enable = true,
      --},

      -- rainbow = {
      --     enable = true,
      --     extended_mode = true,
      --     max_file_lines = nil,
      -- },

      autotag = { enable = true },

      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "tmux",
        "git_config",
        "gitcommit",
        "gitignore",
        "ssh_config",
        -- Python
        "python",
        "toml", --"pip_requirements",
        -- C/C++
        "c",
        "cpp",
        "make",
        "llvm",
        "ninja",
        "cmake",
        -- others
        "bash", --"zsh",
        "regex",
        "yaml",
        "json",
        "xml",
        "html",
        "css",
        "markdown",
        "markdown_inline",
        -- "latex", "bibtex",
        -- "dockerfile",
        -- "sway",
        -- "nginx",
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
