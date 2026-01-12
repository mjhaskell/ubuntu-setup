--vim.api.nvim_create_autocmd("FileType", {
--  pattern = "make",
--  callback = function()
--    vim.opt_local.expandtab = false
--    vim.opt_local.softtabstop = 0
--  end,
--})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "cc", "cxx", "tpp", "h", "hpp", "hh", "hxx" },
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
  end,
})
