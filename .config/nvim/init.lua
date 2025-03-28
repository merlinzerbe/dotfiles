-- options
vim.opt.clipboard = "unnamedplus" -- use the system clipboard
vim.opt.showcmd = false           -- do not show partial commands
vim.opt.showmode = false          -- do not show the current mode
vim.opt.number = true             -- show line numbers
vim.opt.linebreak = true          -- do not split words when wrapping
vim.opt.lazyredraw = true         -- do not update screen while executing macros
vim.opt.shiftround = true         -- round indent to multiple of shiftwidth
vim.opt.ignorecase = true         -- ignore case when searching...
vim.opt.smartcase = true          -- ... except when capital letters are used
vim.opt.swapfile = false          -- do not create swapfiles
vim.opt.undofile = true           -- create undo files
vim.opt.pumheight = 20            -- use 20 lines in the popupmenu at maximum
vim.opt.expandtab = true          -- insert spaces when pressing tab
vim.opt.tabstop = 2               -- use 2 spaces for a tab
vim.opt.shiftwidth = 0            -- use whatever tabstop is
vim.opt.softtabstop = -1          -- use whatever shiftwidth is
-- if splitright is set, step into while debugging does not jump to the function
-- vim.opt.splitright = true         -- more intuitive split positions
vim.opt.splitbelow = true      -- more intuitive split positions
vim.opt.mouse = ""             -- allow select and copy from vim via mouse
vim.opt.shortmess:append("cI") -- do not show intro on startup
vim.opt.laststatus = 1         -- only show statusline if there are multiple windows
vim.opt.inccommand = "nosplit" -- highlight matched words when typing substitution commands
vim.opt.scrolloff = 5          -- keep lines above and below the cursor while scrolling
vim.opt.foldlevelstart = 99    -- expand all folds on start
vim.opt.updatetime = 100       -- check if the file has been changed externally more often
vim.opt.signcolumn = "number"  -- show signs in number column
vim.opt.termguicolors = false  -- use cterm attributes instead of gui attributes for color scheme
vim.opt.modeline = false       -- do no parse vim options from comments in files
vim.g.syntax = false           -- disable regex based syntax highlighting, use treesitter instead

vim.cmd("set spelllang=de")

-- do not use virtual text for diagnostics
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  float = {
    source = true,
  },
})

-- keybindings
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local nore = { noremap = true }
local k = vim.keymap.set

-- general
k({ "n", "v" }, "<space>", "<nop>", { silent = true })
k("n", "<leader>ve", ":edit $MYVIMRC<cr>", nore)
k("n", "<leader>w", ":write<cr>", nore)
k("n", "<leader>q", ":quit<cr>", nore)
k("n", "<leader>x", ":write | quit<cr>", nore)
k("n", "<leader><leader>", "<c-^>", nore) -- switch to previous buffer
k("n", "<leader>i", ":Inspect<cr>", nore)
k("n", "<leader>l", ":Telescope highlights<cr>", nore)
k("n", "s", ":luafile %<cr>", nore)

-- lsp
k("n", "ge", vim.diagnostic.goto_prev, nore)
k("n", "gE", vim.diagnostic.goto_next, nore)
k("n", "<leader>e", vim.diagnostic.open_float, nore)
k("n", "<leader>d", vim.diagnostic.setloclist, nore)
k("n", "<leader>j", ":nohlsearch<cr>", nore) -- remove current search highlighting

-- debugging
k("n", "<f4>", function()
  require("dap").terminate()
end)
k("n", "<f5>", function()
  require("dap").continue()
end)
k("n", "<f6>", function()
  require("dap").step_over()
end)
k("n", "<f7>", function()
  require("dap").step_into()
end)

-- move on visual lines
k({ "n", "x" }, "k", "gk", { silent = true })
k({ "n", "x" }, "j", "gj", { silent = true })

-- easier movement between windows
k("n", "<c-j>", "<c-w>j", nore)
k("n", "<c-k>", "<c-w>k", nore)
k("n", "<c-l>", "<c-w>l", nore)
k("n", "<c-h>", "<c-w>h", nore)

-- go to first non-whitespace character when pressing 0
k("n", "0", "^", nore)
k("n", "^", "0", nore)

-- do not yank when pasting over visual selection
vim.cmd("xnoremap <expr> p '\"_d\"'.v:register.'P'")

-- open terminal with <leader>t
vim.cmd("nnoremap <leader>t :let $VIM_DIR=expand('%:p:h')<cr>:split \\| terminal<cr>cd $VIM_DIR<cr>c<cr>")
vim.cmd('autocmd TermOpen * startinsert " automatically start insert mode when opening term')
vim.cmd("autocmd TermOpen * setlocal listchars= nonumber norelativenumber signcolumn=no laststatus=0 nospell")

-- automatically start in insert mode for git commit messages
vim.cmd("autocmd VimEnter COMMIT_EDITMSG exec 'norm gg' | startinsert!")

-- autoread files when they change outside the editor
vim.cmd(
  "autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() == 'n' && getcmdwintype() == '' | checktime | endif"
)

-- create qr code from selection
vim.cmd("xnoremap <leader>sq :w !qrencode -o - <bar> feh - &<bslash>!<c-b>silent<space><cr>:redraw!<cr>")

-- whitespace settings
vim.cmd("autocmd FileType cs,tex,plaintex,rust,java,nginx,cmake setlocal ts=4 et tw=80")
vim.cmd("autocmd FileType zsh                                   setlocal ts=4 noet")
vim.cmd("autocmd FileType gdscript                              setlocal ts=2 noet")
vim.cmd("autocmd FileType go                                    setlocal ts=4 noet tw=80")
vim.cmd("autocmd FileType python                                setlocal ts=4 et")

-- fold settings
vim.cmd("setlocal foldlevel=1 foldnestmax=1 foldmethod=syntax")
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- abbreviations
vim.cmd("iabbrev rud refactor: update dependencies")
vim.cmd("iabbrev newvue <script setup lang='ts'><cr><cr></script><cr><cr><template><cr><cr></template>")

vim.cmd.colorscheme("16term")

-- reload colorscheme when it changes
local function watch_colorscheme()
  local path = vim.fn.stdpath("config") .. "/colors/16term.lua"
  local event = vim.loop.new_fs_event()
  local function start()
    event:start(path, {}, function()
      event:stop()
      vim.schedule_wrap(function()
        vim.cmd("luafile " .. path)
        start()
      end)()
    end)
  end
  start()
end

watch_colorscheme()

-- dirvish
vim.api.nvim_command("autocmd FileType dirvish nmap <buffer> <esc> gq")
vim.api.nvim_command("autocmd FileType dirvish nmap <buffer> <leader>q gq")

-- return to the last edited line when reopening a file
vim.api.nvim_create_autocmd("BufRead", {
  callback = function(opts)
    vim.api.nvim_create_autocmd("BufWinEnter", {
      once = true,
      buffer = opts.buf,
      callback = function()
        local ft = vim.bo[opts.buf].filetype
        local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
        if
            not (ft:match("commit") and ft:match("rebase"))
            and last_known_line > 1
            and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
        then
          vim.api.nvim_feedkeys([[g`"]], "nx", false)
        end
      end,
    })
  end,
})

-- plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local mason_tool_installer_spec = {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  config = function()
    require("mason-tool-installer").setup({
      ensure_installed = {
        "golines",
        "gofumpt",
        "golangci-lint",
        "prettierd",
        "eslint_d",
        "php-cs-fixer",
        "phpstan",
      },
    })
  end,
}

local mason_spec = {
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
        "phpactor",
      },
    })
  end,
}

local cmp_spec = {
  "hrsh7th/nvim-cmp",
  dependencies = {
    -- snippet engine and corresponding nvim-cmp source
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",

    -- add completions from lsp
    "hrsh7th/cmp-nvim-lsp",

    -- add buffer words completions
    "hrsh7th/cmp-buffer",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    vim.opt.completeopt = "menu,menuone,noinsert"

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      ---@diagnostic disable-next-line: missing-fields
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
      mapping = cmp.mapping.preset.insert({
        ["<c-space>"] = cmp.mapping.complete(),
        ["<cr>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
      }),
      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
      },
    })
  end,
}

local treesitter_spec = {
  -- highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "JoosepAlviste/nvim-ts-context-commentstring", -- set the commentstring based on location in the file
  },
  build = ":TSUpdate",
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup({
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
          },
        },
      },
      highlight = {
        enable = "true",
      },
      ensure_installed = {
        "go",
        "lua",
        "javascript",
        "typescript",
        "tsx",
        "vue",
        "rust",
        "svelte",
        "templ",
        "php",
      },
      ts_context_commentstring = {
        enable = true,
      },
    })
  end,
}

local function find_go_modpath()
  local results = vim.fs.find("go.mod", { upward = true })
  if #results == 0 then
    return nil
  end

  local file_path = results[1]
  local file = io.open(file_path, "r")
  if not file then
    return nil
  end

  for line in file:lines() do
    local module_name = line:match("^module%s+(.+)$")
    file:close()
    return module_name
  end
end

local lspconfig_spec = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvimtools/none-ls.nvim",
    "nvimtools/none-ls-extras.nvim",
    "nvim-telescope/telescope.nvim",
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

    lspconfig["ruff"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["gopls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["phpactor"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    local null_ls = require("null-ls")

    local go_modpath = find_go_modpath()

    local gofumpt_source = null_ls.builtins.formatting.gofumpt
    if go_modpath ~= nil then
      -- gofumpt considers the modpath when grouping imports and we want to
      -- have the same behavior whether calling gofumpt from inside vim or from
      -- the cli, so we add the modpath manually
      gofumpt_source = null_ls.builtins.formatting.gofumpt.with({
        extra_args = { "-modpath", go_modpath },
      })
    end

    null_ls.setup({
      sources = {
        -- formatting and linting for python
        require("none-ls.diagnostics.ruff"),
        require("none-ls.formatting.ruff"),

        -- format php files
        null_ls.builtins.formatting.phpcsfixer,

        -- format typescript/html/css/vue
        null_ls.builtins.formatting.prettierd,

        -- lint typescript/html/css/vue
        -- eslint_d is from none-ls-extras so we have to use require here
        require("none-ls.diagnostics.eslint_d"),

        -- format lua files
        null_ls.builtins.formatting.stylua,

        -- runs goimports and then formats while shortening long lines
        null_ls.builtins.formatting.golines,

        -- gofumpt does stricter formatting than gofmt
        -- unfortunately we cannot use it as a base formatter for golines
        -- https://github.com/segmentio/golines/issues/100
        -- so we run it afterwards and format the file twice
        gofumpt_source,

        null_ls.builtins.diagnostics.golangci_lint,

        -- for typechecking php files
        null_ls.builtins.diagnostics.phpstan,
      },
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format()
            end,
          })
        end
      end,
    })

    lspconfig["pyright"].setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format()
          end,
        })
        on_attach(client, bufnr)
      end,
      settings = {
        disableOrganizeImports = true,
      },
      python = {
        analysis = {
          -- ignore all files for analysis to exclusively use ruff for linting
          ignore = { "*" },
        },
      },
    })

    local mason_registry = require("mason-registry")
    local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
        .. "/node_modules/@vue/language-server"

    lspconfig["ts_ls"].setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        -- we use prettier so we do not want ts_ls to format our code
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

        on_attach(client, bufnr)
      end,
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
      on_attach = function(client, bufnr)
        -- we use prettier so we do not want volar to format our code
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

        on_attach(client, bufnr)
      end,
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
        local active_clients = vim.lsp.get_clients()
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

    local typst_font_paths_env = os.getenv("TYPST_FONT_PATHS")
    local typst_font_paths = nil
    if typst_font_paths_env ~= nil then
      typst_font_paths = { typst_font_paths_env }
    end

    require("lspconfig")["tinymist"].setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        -- force formatting, idk why this does not work automatically
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format()
          end,
        })
      end,
      settings = {
        formatterMode = "typstyle",
        exportPdf = "onType",
        semanticTokens = "disable",
        fontPaths = typst_font_paths,
      },
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

local telescope_spec = {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    telescope.setup({
      defaults = {
        sorting_strategy = "ascending",
        layout_config = {
          prompt_position = "top",
        },
        mappings = {
          i = {
            ["<esc>"] = actions.close,
          },
        },
      },
    })

    telescope.load_extension("fzf")

    vim.keymap.set("n", "<leader>h", require("telescope.builtin").oldfiles)
    vim.keymap.set("n", "<leader>b", require("telescope.builtin").buffers)
    vim.keymap.set("n", "<leader>f", require("telescope.builtin").find_files)
    vim.keymap.set("n", "<leader>g", require("telescope.builtin").live_grep)
    vim.keymap.set("n", "<leader>p", require("telescope.builtin").commands)
    vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics)
    vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume)
  end,
}

local markdown_preview_spec = {
  -- preview markdown files
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
}

require("lazy").setup({
  mason_spec,
  mason_tool_installer_spec,
  cmp_spec,
  lspconfig_spec,
  treesitter_spec,
  markdown_preview_spec,
  telescope_spec,
  "justinmk/vim-dirvish",
  "folke/neodev.nvim",
}, {
  change_detection = {
    notify = false,
  },
})

local local_file = vim.fn.stdpath("config") .. "/local.lua"
if vim.fn.filereadable(local_file) == 1 then
  dofile(local_file)
end
