vim.cmd("let g:netrw_liststyle = 3") -- tree structure
vim.cmd("colorscheme vscode")

vim.o.list = true
-- vim.o.listchars = "space:·,tab:|->,trail:•,extends:»,precedes:«"
vim.o.listchars = "space: ,multispace:·,lead:·,trail:•,tab:|->,extends:»,precedes:«,nbsp:‿"
-- vim.o.listchars = "nbsp:_,tab:|->,trail:•,extends:»,precedes:«"

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

local opt = vim.opt

opt.autowrite = true -- save changes whenever it would be needed (leaving buffer)
opt.confirm = true -- confirm to save changes before exiting modified buffer
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2 -- hide * markup for bold/italic, but not markers with substitutions

opt.textwidth = 120
opt.wrap = true -- wrap text after textwidth
opt.colorcolumn = "81,91,121"

opt.mouse = "a" -- Allow mouse to move cursor

-- use system keyboard unless on SSH, then use empty string register
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"

opt.relativenumber = true
opt.number = true -- show current line number

vim.opt.splitright = true
vim.opt.splitbelow = true

opt.tabstop = 6 -- set spacing of literal tab "\t" characters
opt.softtabstop = 4 -- set spacing when I hit tab
opt.shiftwidth = 4 -- set indent spacing to 4
opt.expandtab = true -- change tab to spaces
opt.smarttab = true
--opt.autoindent = true -- indent newline like current line

opt.ignorecase = true -- ignore case in searches
opt.smartcase = true -- if search term is capitalized, search becomes case sensitive
opt.magic = true -- allow pattern matching with special characters
opt.lazyredraw = true -- don't redraw while executing macros

opt.cursorline = true -- draw horizontal line under cursor line
opt.ruler = true -- show cursor position at bottom right of screen

opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be dark
opt.signcolumn = "yes" -- show sign columns so that text doesn't shift

opt.backspace = "indent,eol,start" -- where to allow backspace in insert mode

opt.swapfile = false

-- chech if these are still needed
opt.encoding = "UTF-8"
opt.lazyredraw = true
opt.backup = false

--vim.cmd("set clipboard=unnamedplus") -- Always copy and paste to clipboard
--vim.cmd("let g:clipboard = {
--
--}")

-- cursor settings
--vim.cmd('let &t_SI.="\e[5 q"') -- SI = INSERT mode
--vim.cmd('let &t_SR.="\e[4 q"') -- SR = REPLACE mode
--vim.cmd('let &t_EI.="\e[1 q"') -- EI = NORMAL mode (ELSE)

--vim.cmd('let &t_ti.="\e[1 q"') -- ti = entering nvim from terminal
--vim.cmd('let &t_te.="\e[  q"') -- te = leaving vim (set back to terminal default)

--  1 -> blinking block
--  2 -> solid block
--  3 -> blinking underscore
--  4 -> solid underscore
--  5 -> blinking vertical bar
--  6 -> solid vertical bar
