return {
  "Civitasv/cmake-tools.nvim",
  opts = {},

  config = function()
    require("cmake-tools").setup({
      cmake_dap_configuration = { -- debug settings for cmake
        name = "cpp",
        type = "codelldb",
        request = "launch",
        stopOnEntry = false, -- default is false
        runInTerminal = true,
        console = "integratedTerminal",
      },
    })
  end,

  keys = {
    { "<leader>C", mode = { "n" }, "", desc = "CMake tools" },
    { "<leader>Cb", mode = { "n" }, "<cmd>CMakeBuild<CR>", desc = "CMake build" },
    { "<leader>Cr", mode = { "n" }, "<cmd>CMakeRun<CR>", desc = "CMake run" },
    { "<leader>Ct", mode = { "n" }, "<cmd>CMakeRunTest<CR>", desc = "CMake run test" },
    { "<leader>CR", mode = { "n" }, "<cmd>CMakeRunCurrentFile<CR>", desc = "CMake run current file" },
    { "<leader>Cd", mode = { "n" }, "<cmd>CMakeDebug<CR>", desc = "CMake debug" },
    { "<leader>CD", mode = { "n" }, "<cmd>CMakeDebugCurrentFile<CR>", desc = "CMake debug current file" },
    { "<leader>Cg", mode = { "n" }, "<cmd>CMakeGenerate<CR>", desc = "CMake generate" },
    { "<leader>Cx", mode = { "n" }, "<cmd>CMakeClean<CR>", desc = "CMake clean" },
    { "<leader>Cc", mode = { "n" }, "<cmd>CMakeCache<CR>", desc = "CMake cache" },

    { "<leader>Cs", mode = { "n" }, "", desc = "CMake select menu" },
    { "<leader>Csd", mode = { "n" }, "<cmd>CMakeSelectBuildDir<CR>", desc = "CMake select build dir" },
    { "<leader>Cst", mode = { "n" }, "<cmd>CMakeSelectBuildType<CR>", desc = "CMake select build type" },
    { "<leader>Csb", mode = { "n" }, "<cmd>CMakeSelectBuildTarget<CR>", desc = "CMake select build target" },
    { "<leader>Csr", mode = { "n" }, "<cmd>CMakeSelectLaunchTarget<CR>", desc = "CMake select launch target" },
    { "<leader>Csk", mode = { "n" }, "<cmd>CMakeSelectKit<CR>", desc = "CMake select kit" },
    { "<leader>Csc", mode = { "n" }, "<cmd>CMakeSelectCwd<CR>", desc = "CMake select cwd" },
  },
}
