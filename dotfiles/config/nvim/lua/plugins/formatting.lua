return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        liquid = { "prettier" },
        lua = { "stylua" },
        -- python = { "isort", "black" },
        python = { "black" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        rust = { "clang_format" },
      },

      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
      -- format_on_save = {
      --   enable = false,
      --   lsp_fallback = true,
      --   async = false,
      --   timeout_ms = 1000,
      -- },
      formatters = {
        clang_format = {
          -- prepend_args = { "--style=file", '--fallback-style=LLVM'}
          prepend_args = { "--style=file" },
        },
      },
    })

    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })

    vim.api.nvim_create_user_command("PrintFormatEnabled", function()
      local gformat = tostring(not vim.g.disable_autoformat)
      local lformat = tostring(not vim.b.disable_autoformat)
      print(string.format("global: %s, local: %s", gformat, lformat))
    end, {
      desc = "Print whether format-on-save is enabled",
    })

    vim.keymap.set("n", "<leader>ce", ":FormatEnable<CR>", { desc = "Enable format-on-save" })
    vim.keymap.set("n", "<leader>cd", ":FormatDisable!<CR>", { desc = "Disable format-on-save for this file" })
    vim.keymap.set("n", "<leader>cD", ":FormatDisable<CR>", { desc = "Disable format-on-save globally" })
    vim.keymap.set("n", "<leader>ci", ":PrintFormatEnabled<CR>", { desc = "Print format-on-save info" })

    vim.keymap.set({ "n", "v" }, "<leader>cf", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
