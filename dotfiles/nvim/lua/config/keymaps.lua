-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local km = vim.keymap
local cmd = vim.cmd

km.set("i", "jk", "<ESC>", {desc="Exit insert mode with jk"})
km.set("n", "<ctrl>s", ":w<CR>", {desc="Save file"})
km.set("n", "<leader>pv", vim.cmd.Ex, {desc="Open native file explorer"})
km.set("v", "p", '"_dP', {desc="Paste without yank after"})
km.set("n", "<leader>nh", ":nohl<CR>", {desc="Clear search highlights"})
km.set("n", "<leader>l", ":Lazy<CR>", {desc="Open lazy menu"})

-- increment/decrement numbers
km.set("n", "<leader>+", "<C-a>", {desc="Increment number"})
km.set("n", "<leader>-", "<C-x>", {desc="Decrement number"})

-- window management
km.set("n", "<leader>sv", "<C-w>v", {desc="Split window vertically"})
km.set("n", "<leader>sh", "<C-w>s", {desc="Split window horizontally"})
km.set("n", "<leader>se", "<C-w>=", {desc="Make splits equal size"})
km.set("n", "<leader>sx", "<cmd>close<CR>", {desc="Close current split"})

km.set("n", "<leader>th", "<cmd>tabp<CR>", {desc="Go to previous tab"})
km.set("n", "<leader>tl", "<cmd>tabn<CR>", {desc="Go to next tab"})
km.set("n", "<leader>tH", "<cmd>-tabmove<CR>", {desc="Move tab left"})
km.set("n", "<leader>tL", "<cmd>+tabmove<CR>", {desc="Move tab right"})
km.set("n", "<leader>t0", "<cmd>tabfirst<CR>", {desc="Go to 1st tab"})
km.set("n", "<leader>t$", "<cmd>tablast<CR>", {desc="Go to last tab"})
km.set("n", "<leader>tf", "<cmd>tabnew %<CR>", {desc="Open current buffer in new tab"})
km.set("n", "<leader>to", "<cmd>tabnew<CR>", {desc="Open new tab"})
km.set("n", "<leader>tx", "<cmd>tabclose<CR>", {desc="Close current tab"})


-- Easy access to edit and source nvim config
km.set("n", "<leader>sv", function()
  vim.cmd('source ~/.config/nvim/init.lua')
  print("Configuration reloaded")
end, { desc = "Re-source Neovim configuration file" })
km.set("n", "<leader>so", function ()
    vim.cmd('source ~/.config/nvim/lua/config/options.lua')
    print("nvim options reloaded")
  end, {desc="Source nvim options file"})
km.set("n", "<leader>sk", function ()
    vim.cmd('source ~/.config/nvim/lua/config/keymaps.lua')
    print("nvim keymaps reloaded")
  end, {desc="Source nvim keymaps file"})
km.set("n", "<leader>vo", function()
  vim.cmd('tabedit ~/.config/nvim/lua/config/options.lua')
end, { desc = "Edit keymaps file in vsplit" })
km.set("n", "<leader>vk", function()
  vim.cmd('vsplit ~/.config/nvim/lua/config/keymaps.lua')
end, { desc = "Edit keymaps file in vsplit" })

