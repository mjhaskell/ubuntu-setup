return {
  "neovim/nvim-lspconfig",

  event = { "BufReadPre", "BufNewFile" },

  dependencies = {
    "hrsh7th/cmp-nvim-lsp",

    { "antosha417/nvim-lsp-file-operations", config = true },
    -- { "folke/neodev.nvim", opts = {} },
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },

    { -- optional cmp completion source for require statements and module annotations
      "hrsh7th/nvim-cmp",
      opts = function(_, opts)
        opts.sources = opts.sources or {}
        table.insert(opts.sources, {
          name = "lazydev",
          group_index = 0, -- set group index to 0 to skip loading LuaLS completions
        })
      end,
    },

    { -- optional blink completion source for require statements and module annotations
      "saghen/blink.cmp",
      build = "cargo build --release",
      -- enabled = vim.g.blink_enabled,
      opts = {
        keymap = { preset = "default" },
        appearance = { nerd_font_variant = "mono" },
        completion = { documentation = { auto_show = true } },
        signature = { enabled = true },
        sources = {
          -- add lazydev to your completion providers
          default = { "lazydev", "lsp", "path", "snippets", "buffer" },
          providers = {
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              -- make lazydev completions top priority (see `:h blink.cmp`)
              score_offset = 100,
            },
          },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
      },
      opts_extend = { "sources.default" },
    },
  },

  opts = {
    servers = {
      lua_ls = {},
      clangd = {},
      -- pyright = { cmd = { vim.env.HOME .. "/.pyvenvs/default/bin/pyright-langserver", "--stdio" } },
      pyright = {},
      ltex = {},
    },
  },

  config = function(_, opts)
    -- import lspconfig plugin
    -- local lspconfig = require("lspconfig")  -- DEPRECATED
    -- lspconfig.pyright.setup({
    --   cmd = { "pyright-langserver", "--stdio" },
    -- })

    -- import mason_lspconfig plugin
    local mason_lspconfig = require("mason-lspconfig")

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local km_opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        km_opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", km_opts) -- show definition, references

        km_opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, km_opts)

        km_opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", km_opts)

        km_opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", km_opts)

        km_opts.desc = "Show LSP type definitions"
        keymap.set("n", "gl", "<cmd>Telescope lsp_type_definitions<CR>", km_opts)

        km_opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, km_opts) -- in visual mode will apply to selection

        km_opts.desc = "Smart rename"
        keymap.set("n", "<leader>cr", vim.lsp.buf.rename, km_opts)

        km_opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>xD", "<cmd>Telescope diagnostics bufnr=0<CR>", km_opts)

        km_opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>xd", vim.diagnostic.open_float, km_opts)

        km_opts.desc = "Go to previous diagnostic"
        -- keymap.set("n", "[d", vim.diagnostic.goto_prev, km_opts)  -- DEPRECATED
        keymap.set("n", "[d", function()
          vim.diagnostic.jump({ count = -1, float = true })
        end, km_opts)

        km_opts.desc = "Go to next diagnostic"
        -- keymap.set("n", "]d", vim.diagnostic.goto_next, km_opts) -- DEPRECATED
        keymap.set("n", "]d", function()
          vim.diagnostic.jump({ count = 1, float = true })
        end, km_opts)

        km_opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, km_opts)

        km_opts.desc = "Restart LSP"
        keymap.set("n", "<leader>cl", ":LspRestart<CR>", km_opts)
      end,
    })

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    -- local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    -- for type, icon in pairs(signs) do
    --   local hl = "DiagnosticSign" .. type
    --   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    -- end

    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.HINT] = "󰠠",
          [vim.diagnostic.severity.INFO] = "",
        },
        linehl = {
          [vim.diagnostic.severity.ERROR] = "ErrorLine",
          [vim.diagnostic.severity.WARN] = "WarningLine",
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = "ErrorSign",
        },
      },
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    for server, config in pairs(opts.servers) do
      config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
      vim.lsp.config(server, config)
      -- lspconfig[server].setup(config)  -- DEPRECATED
    end

    -- mason_lspconfig.setup_handlers({
    --   -- default handler for installed servers
    --   function(server_name)
    --     lspconfig[server_name].setup({
    --       capabilities = capabilities,
    --     })
    --   end,
    --   -- ["svelte"] = function()
    --   --   -- configure svelte server
    --   --   lspconfig["svelte"].setup({
    --   --     capabilities = capabilities,
    --   --     on_attach = function(client, bufnr)
    --   --       vim.api.nvim_create_autocmd("BufWritePost", {
    --   --         pattern = { "*.js", "*.ts" },
    --   --         callback = function(ctx)
    --   --           -- Here use ctx.match instead of ctx.file
    --   --           client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
    --   --         end,
    --   --       })
    --   --     end,
    --   --   })
    --   -- end,
    --   -- ["graphql"] = function()
    --   --   -- configure graphql language server
    --   --   lspconfig["graphql"].setup({
    --   --     capabilities = capabilities,
    --   --     filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
    --   --   })
    --   -- end,
    --   -- ["emmet_ls"] = function()
    --   --   -- configure emmet language server
    --   --   lspconfig["emmet_ls"].setup({
    --   --     capabilities = capabilities,
    --   --     filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
    --   --   })
    --   -- end,
    --   ["lua_ls"] = function()
    --     -- configure lua server (with special settings)
    --     lspconfig["lua_ls"].setup({
    --       capabilities = capabilities,
    --       settings = {
    --         Lua = {
    --           -- make the language server recognize "vim" global
    --           diagnostics = {
    --             globals = { "vim" },
    --           },
    --           completion = {
    --             callSnippet = "Replace",
    --           },
    --         },
    --       },
    --     })
    --   end,
    -- })
  end,
}
