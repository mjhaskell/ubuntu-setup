return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  -- branch = '0.1.x',
  dependencies = {
    -- optional system dependencies for improved performance --

    -- ripgrep (alternate to grep - required for live_grep)
      -- sudo apt install ripgrep
      -- sudo pacman -S ripgrep
    
    -- fd (alternate to find)
      -- sudo apt install fd 
    'nvim-lua/plenary.nvim',
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
    local ts = require("telescope")
    local act = require("telescope.actions")

    ts.setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = act.move_selection_previous, -- move to prev result
            ["<C-j>"] = act.move_selection_next, -- move to next result
            ["<C-q>"] = act.send_selected_to_qflist + act.open_qflist,
          },
        },
      },
    })

    ts.load_extension("fzf")


    local builtin = require("telescope.builtin")
    local km = vim.keymap
    km.set("n", "<leader>ff", builtin.find_files, {desc="fzf find file"})
    --km.set("n", "<leader>fr", builtin.oldfiles, {desc="fzf find recent files"})
    km.set("n", "<leader>fg", builtin.live_grep, {desc="Live grep"})
    km.set("n", "<leader>fb", builtin.buffers, {desc="fzf buffers"})
    km.set("n", "<leader>fh", builtin.help_tags, {desc="fzf help tags"})
    km.set("n", "<leader>fc", builtin.grep_string, {desc="Find string under cursor"})
    km.set("n", "<leader>fs", function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end, {desc="Grep word"})
    -- km.set("n", "<leader>ft", function()
    --     builtin.tags({ search = vim.fn.input("Tags > ") })
    -- end)
    km.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", {desc="Find TODOs"})

  end,
}
