return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
  },
  opts = {
    controls = {
      enabled = false,
    },
    expand_lines = false,
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.50 },
          { id = "watches", size = 0.25 },
          { id = "stacks", size = 0.25 },
        },
        size = 0.5,
        position = "right",
      },
      {
        elements = {
          "repl",
        },
        size = 10,
        position = "bottom",
      },
    },
  },
  config = function()
    local dap = require("dap")

    dap.configurations.go = {
      {
        type = "delve",
        name = "Debug",
        request = "launch",
        showLog = false,
        program = "${file}",
        dlvToolPath = vim.fn.exepath("dlv"),
        args = function()
          local args_string = vim.fn.input("Arguments: ")
          return vim.split(args_string, " +")
        end,
      },
    }
  end,
}
