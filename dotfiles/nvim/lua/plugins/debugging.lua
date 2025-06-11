return {
  "rcarriga/nvim-dap-ui",

  dependencies = {
    -- generic
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",

    -- languages
    "mfussenegger/nvim-dap-python",
  },

  config = function()
    local dap = require("dap")
    local ui = require("dapui")
    ui.setup()

    local vtext = require("nvim-dap-virtual-text")
    vtext.setup({
      enabled = false,
      virt_text_pos = "eol", -- default is 'inline'
      virt_text_win_col = 90,
      display_callback = function(variable)
        local name = string.lower(variable.name)
        local value = string.lower(variable.value)
        if name:match("secret") or name:match("api") or name:match("token") then
          return " ***** "
        end

        if #variable.value > 15 then
          return " " .. string.sub(variable.value, 1, 15) .. " ... "
        end

        return " " .. variable.value
      end,
    })

    -- languages with extensions
    require("dap-python").setup("python")

    -- languages without extensions
    dap.adapters.gdb = { -- C/C++/Rust
      id = "gdb",
      type = "executable",
      command = "gdb",
      args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
    }
    dap.adapters.cppdbg = { -- C/C++/Rust
      id = "cppdbg",
      type = "executable",
      -- TODO: verify path of VS Code's cpptools extension
      command = os.getenv("HOME")
        .. "/.vscode/extensions/ms-vscode.cpptools-1.25.3-linux-x64"
        .. "/debugAdapters/bin/OpenDebugAD7",
    }
    dap.adapters.codelldb = { -- C/C++/Rust
      id = "codelldb",
      type = "executable",
      -- command = "codelldb",
      command = os.getenv("HOME")
        .. "/.vscode/extensions/vadimcn.vscode-lldb-1.11.5/adapter/codelldb",
    }

    dap.configurations.c = {
      {
        name = "Debug executable (codelldb)",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopAtEntry = false,
        setupCommands = {
          {
            text = "-enable-pretty-printing",
            desc = "enable pretty printing",
            ignoreFailures = false,
          },
        },
      },
      {
        name = "Debug executable (cpptools)",
        type = "cppdbg",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopAtEntry = true,
        setupCommands = {
          {
            text = "-enable-pretty-printing",
            desc = "enable pretty printing",
            ignoreFailures = false,
          },
        },
      },
      {
        name = "Debug executable with arguments (cpptools)",
        type = "cppdbg",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        args = function()
          local args_str = vim.fn.input({
            prompt = "Arguments: ",
          })
          return vim.split(args_str, " +")
        end,
        cwd = "${workspaceFolder}",
        stopAtEntry = true,
        setupCommands = {
          {
            text = "-enable-pretty-printing",
            desc = "enable pretty printing",
            ignoreFailures = false,
          },
        },
      },
      {
        name = "Debug executable (gdb)",
        type = "gdb",
        request = "launch",
        program = function()
          local path = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          return (path and path ~= "") and path or dap.ABORT
        end,
        cwd = "${workspaceFolder}",
        stopAtBeginningOfMainSubprogram = false,
      },
      {
        name = "Debug executable with arguments (gdb)",
        type = "gdb",
        request = "launch",
        program = function()
          local path = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          return (path and path ~= "") and path or dap.ABORT
        end,
        args = function()
          local args_str = vim.fn.input({
            prompt = "Arguments: ",
          })
          return vim.split(args_str, " +")
        end,
        cwd = "${workspaceFolder}",
        stopAtBeginningOfMainSubprogram = false,
      },
      {
        name = "Select and attach to process (gdb)",
        type = "gdb",
        request = "attach",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        pid = function()
          local name = vim.fn.input("Executable name (filter): ")
          return require("dap.utils").pick_process({ filter = name })
        end,
        cwd = "${workspaceFolder}",
      },
      {
        name = "Attach to gdbserver :1234",
        type = "gdb",
        request = "attach",
        target = "localhost:1234",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
      },
      {
        name = "Attach to gdbserver :1234 (cpptools)",
        type = "cppdbg",
        request = "launch", -- maybe should be 'attach'
        MIMode = "gdb",
        miDebuggerServerAddress = "localhost:1234",
        miDebuggerPath = "/usr/bin/gdb",
        cwd = "${workspaceFolder}",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        setupCommands = {
          {
            text = "-enable-pretty-printing",
            desc = "enable pretty printing",
            ignoreFailures = false,
          },
        },
      },
    }
    dap.configurations.cpp = dap.configurations.c
    dap.configurations.rust = dap.configurations.c

    -- config from nvim-dap-ui to automatically open ui when debugging
    dap.listeners.before.attach.dapui_config = function()
      ui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      ui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      ui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      ui.close()
    end

    -- change breakpoint symbol
    vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })

    -- custom keymaps
    vim.keymap.set("n", "<leader>dv", vtext.toggle, { desc = "Debug: toggle virtual text (current values)" })
    vim.keymap.set("n", "<leader>du", ui.toggle, { desc = "Dap UI toggle" })
    vim.keymap.set("n", "<leader>d?", ui.eval, { desc = "Debug: Evaluate under cursor or visually selected" })
    vim.keymap.set("n", "<leader>dk", ui.eval, { desc = "Debug: Evaluate under cursor or visually selected" })
    vim.keymap.set("n", "<leader>dh", dap.run_to_cursor, { desc = "Debug: run to cursor (here)" })
    vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Debug: run last session" })

    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
    vim.keymap.set("n", "<leader>d<CR>", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
    vim.keymap.set("n", "<leader>d<BS>", dap.clear_breakpoints, { desc = "Remove all breakpoint" })

    vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: continue" })
    vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug: continue" })

    vim.keymap.set("n", "<F4>", dap.step_over, { desc = "Debug: step over" })
    vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "Debug: step over" })

    vim.keymap.set("n", "<F6>", dap.step_into, { desc = "Debug: step into" })
    vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug: step into" })

    vim.keymap.set("n", "<F9>", dap.step_out, { desc = "Debug: step out" })
    vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Debug: step out" })

    vim.keymap.set("n", "<leader>dp", dap.step_back, { desc = "Debug: step back (previous)" })

    vim.keymap.set("n", "<F1>", dap.restart, { desc = "Debug: restart" })
    vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "Debug: restart" })

    vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "Debug: stop" })
  end,
}
