return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local on_attach = function(client, bufnr)
      local nmap = function(keys, func, desc)
        if desc then
          desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
      end

      nmap("<leader>r", vim.lsp.buf.rename)
      nmap("<leader>a", vim.lsp.buf.code_action)
      vim.keymap.set("v", "<leader>a", vim.lsp.buf.code_action, { buffer = bufnr })
      nmap("<leader>e", vim.lsp.buf.hover)
      nmap("gD", vim.lsp.buf.declaration)
      nmap("gd", require("telescope.builtin").lsp_definitions)
      nmap("gr", require("telescope.builtin").lsp_references)
      nmap("gi", require("telescope.builtin").lsp_implementations)
      nmap("gy", require("telescope.builtin").lsp_type_definitions)
    end

    local capabilities = cmp_nvim_lsp.default_capabilities()

    lspconfig["omnisharp"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      cmd = { "dotnet", vim.fn.stdpath("data") .. "/mason/packages/omnisharp/libexec/OmniSharp.dll" },
      enable_import_completion = true,
      organize_imports_on_format = true,
      enable_roslyn_analyzers = true,
      root_dir = lspconfig.util.root_pattern("*.csproj"),
    })

    lspconfig["ruff"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["gopls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["golangci_lint_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["pyright"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    local mason_registry = require("mason-registry")
    local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
      .. "/node_modules/@vue/language-server"

    lspconfig["ts_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      init_options = {
        plugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_language_server_path,
            languages = { "vue" },
          },
        },
      },
      filetypes = {
        "typescript",
        "typescriptreact",
        "javascript",
        "vue",
      },
    })

    lspconfig["volar"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["html"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "html", "templ" },
    })

    lspconfig["svelte"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["emmet_language_server"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "html", "templ" },
    })

    vim.filetype.add({ extension = { templ = "templ" } })
    lspconfig["templ"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["denols"].setup({
      root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
      init_options = {
        lint = true,
        unstable = true,
        suggest = {
          imports = {
            hosts = {
              ["https://deno.land"] = true,
              ["https://cdn.nest.land"] = true,
              ["https://crux.land"] = true,
            },
          },
        },
      },
      on_attach = function(client, bufnr)
        local active_clients = vim.lsp.get_active_clients()
        for _, active_client in pairs(active_clients) do
          -- stop tsserver if denols is active
          if active_client.name == "ts_ls" then
            active_client.stop()
          end
        end
        on_attach(client, bufnr)
      end,
    })

    -- vim detects .typ files as sql
    -- we need to add this manually so that the lsp is properly attached
    vim.filetype.add({ extension = { typ = "typst" } })
    lspconfig["tinymist"].setup({
      offset_encoding = "utf-8",
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        exportPdf = "onSave",
      },
      root_dir = function()
        return vim.fn.getcwd()
      end,
      single_file_support = true,
    })

    lspconfig["lua_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          -- make the language server recognize the "vim" global
          diagnostics = {
            globals = {
              "vim",
            },
          },
          workspace = {
            -- make the languages server aware of runtime files
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })
  end,
}
