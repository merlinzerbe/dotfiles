return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  config = function()
    require("mason-tool-installer").setup({
      ensure_installed = {
        "golines",
        "gofumpt",
        "golangci-lint",
      },
    })
  end,
}
