return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },

  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      automatic_enable = true,

      -- list of servers for mason to install
      ensure_installed = {
        -- Lua
        "lua_ls",

        -- Python
        "pyright", -- LSP
        -- "pylsp", -- LSP
        -- "autopep8", -- formatter
        -- "black", -- formatter
        -- "debugpy",
        -- TODO: install plugins: nvim-dap and nvim-dap-python

        -- C++
        "clangd", -- actual LSP
        -- "clang-format", -- formats code
        -- "cpplint", -- linter following Google's style guide (doesn't change code)
        -- "cpptools", -- VS Code tool for debugging (DAP)

        -- Latex
        "texlab", -- LSP
        "ltex", -- grammar and spell checking LSP

        -- Bash
        "bashls", -- nothing specifically for zsh

        -- Markdown
        "marksman",
        -- "ltex", -- specll checking
        -- "markdown-toc", -- generate and update TOC

        -- JSON
        -- "json-lsp",
        -- "jq", -- formatter

        -- YAML
        "yamlls", -- LSP
        -- "yamlfmt", -- formatter
        -- "yamllint", -- linter for style and error checking

        -- XML
        "lemminx",

        -- Web: html, css, typescript, javascript
        -- "html",
        -- "cssls",
        -- "tsserver",
        -- "emmet_ls",
        -- "graphql",
        -- "prismals",
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "stylua",

        -- "isort", -- python
        "black", -- python
        "pylint",
        "debugpy",

        "clang-format",
        "cpplint",
        "cpptools",
        "cmakelang",
        "cmakelint",

        "prettier",
        -- "markdown_toc",
        -- "eslint_d", -- js
      },
    })
  end,
}
