--vim.api.nvim_create_autocmd("FileType", {
--  pattern = "make",
--  callback = function()
--    vim.opt_local.expandtab = false
--    vim.opt_local.softtabstop = 0
--  end,
--})

-- vim.api.nvim_create_autocmd("FileType", {
--   callback = function(args)
--     local lang = vim.treesitter.language.get_lang(args.match)
--     if lang then
--       vim.treesitter.start(args.buf, lang)
--     end
--   end,
-- })

-- vim.api.nvim_create_autocmd("FileType", {
--   callback = function(args)
--     local lang = vim.treesitter.language.get_lang(args.match)
--     if lang and require("nvim-treesitter.parsers").has_parser(lang) then
--       vim.treesitter.start(args.buf, lang)
--     end
--   end,
-- })

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("treesitter-enable", { clear = true }),
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if not lang or not vim.treesitter.language.add(lang) then
      return
    end

    if vim.treesitter.query.get(lang, "highlights") then
      vim.treesitter.start(args.buf)
    end

    if vim.treesitter.query.get(lang, "indents") then
      vim.opt_local.indentexpr = 'v:lua.require("nvim-treesitter").indentexpr()'
    end

    if vim.treesitter.query.get(lang, "folds") then
      vim.opt_local.foldmethod = "expr"
      vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "cc", "cxx", "tpp", "h", "hpp", "hh", "hxx", "cmake" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
    vim.opt_local.textwidth = 90
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  --pattern = {"python", "py", "pyc"},
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 6
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
    vim.opt_local.textwidth = 90

    vim.keymap.set("n", "<localleader><CR>", function()
      local vs = require("venv-selector")
      local py = vs.python()
      Snacks.terminal(py .. " " .. vim.api.nvim_buf_get_name(0), { win = { position = "float" } })
    end, { desc = "Run current file with selected venv" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
    vim.opt_local.textwidth = 90
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
    vim.opt_local.spell = true
  end,
})
