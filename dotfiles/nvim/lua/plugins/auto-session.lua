return {
	"rmagatti/auto-session",

	config = function()
		local as = require("auto-session")

		as.setup({
			auto_restore_enabled = false,
			auto_session_suppress_dirs = { "~/" },
		})

		local km = vim.keymap

		-- restore last workspace session for current directory
		km.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })

		-- save workspace session for current working directory
		km.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" })
	end,
}
