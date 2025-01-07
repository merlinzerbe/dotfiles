return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")

    mason.setup({})

    mason_lspconfig.setup({
      ensure_installed = {
        "gopls",
        "lua_ls",
        "pyright",
        "volar",
        "ts_ls",
        "templ",
        "html",
        "emmet_language_server",
        "svelte",
        "ruff",
        "denols",
        "omnisharp",
        "tinymist",
      },
    })
  end,
}
