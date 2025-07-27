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
vim.opt.splitbelow = true                                                 -- more intuitive split positions
vim.opt.mouse = ""                                                        -- allow select and copy from vim via mouse
vim.opt.shortmess:append("cI")                                            -- do not show intro on startup
vim.opt.laststatus = 1                                                    -- only show statusline if there are multiple windows
vim.opt.scrolloff = 5                                                     -- keep lines above and below the cursor while scrolling
vim.opt.updatetime = 100                                                  -- check if the file has been changed externally more often
vim.opt.signcolumn = "number"                                             -- show signs in number column
vim.opt.termguicolors = false                                             -- use cterm attributes instead of gui attributes for color scheme
vim.opt.modeline = false                                                  -- do no parse vim options from comments in files
vim.opt.guicursor:remove({ "t:block-blinkon500-blinkoff500-TermCursor" }) -- disable cursor blinking in embedded terminal
vim.g.syntax = false                                                      -- disable regex based syntax highlighting, use treesitter instead

vim.cmd("set spelllang=de")

vim.cmd.colorscheme("16term")

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
k("n", "ge", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, nore)
k("n", "gE", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, nore)
k("n", "<leader>e", vim.diagnostic.open_float, nore)
k("n", "<leader>d", vim.diagnostic.setloclist, nore)
k("n", "<leader>j", ":nohlsearch<cr>", nore) -- remove current search highlighting

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

-- quit dirvish with <esc> or <leader>q
vim.api.nvim_command("autocmd FileType dirvish nmap <buffer> <esc> gq")
vim.api.nvim_command("autocmd FileType dirvish nmap <buffer> <leader>q gq")

-- do not yank when pasting over visual selection
vim.cmd("xnoremap <expr> p '\"_d\"'.v:register.'P'")

-- open terminal with <leader>t
vim.cmd("nnoremap <leader>t :let $VIM_DIR=expand('%:p:h')<cr>:split \\| terminal<cr>cd $VIM_DIR<cr>c<cr>")
vim.cmd("autocmd TermOpen * startinsert") -- automatically start insert mode when opening term
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

-- abbreviations
vim.cmd("iabbrev rud refactor: update dependencies")
vim.cmd("iabbrev newvue <script setup lang='ts'><cr><cr></script><cr><cr><template><cr><cr></template>")

vim.cmd.colorscheme("16term")

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

local mason_spec = {
  "mason-org/mason.nvim",
  config = function()
    local mason = require("mason")
    local registry = require("mason-registry")
    mason.setup()
    local tools = {
      "delve",
      "deno",
      "djlint",
      "eslint_d",
      "gofumpt",
      "golangci-lint",
      "golines",
      "gopls",
      "lua-language-server",
      "phpactor",
      "phpcbf",
      "phpcs",
      "phpstan",
      "prettierd",
      "ruff",
      "shellcheck",
      "shfmt",
      "templ",
      "tinymist",
      "ty",
      "vtsls",
      "vue-language-server",
    }

    for _, tool in ipairs(tools) do
      local pkg = registry.get_package(tool)
      if not pkg:is_installed() then
        vim.cmd("MasonInstall " .. tool)
      end
    end
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

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
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
        "twig",
        "bash",
      },
      ts_context_commentstring = {
        enable = true,
      },
    })
  end,
}

local lspconfig_spec = {
  "neovim/nvim-lspconfig",
  dependencies = {
    "nvimtools/none-ls.nvim",
    "nvimtools/none-ls-extras.nvim",
    "nvim-telescope/telescope.nvim",
    {
      "ray-x/lsp_signature.nvim",
      commit = "292366",
    },
  },
  config = function()
    local vue_language_server_path = vim.fn.stdpath("data")
        .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

    local vue_plugin = {
      name = "@vue/typescript-plugin",
      location = vue_language_server_path,
      languages = { "vue" },
      configNamespace = "typescript",
    }

    local vtsls_config = {
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              vue_plugin,
            },
          },
        },
      },
      filetypes = {
        "typescript",
        "javascript",
        "javascriptreact",
        "typescriptreact",
        "vue",
      },
    }

    vim.lsp.config("vtsls", vtsls_config)

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

    local go_modpath = find_go_modpath()

    local null_ls = require("null-ls")

    local gofumpt_source = null_ls.builtins.formatting.gofumpt
    if go_modpath ~= nil then
      -- gofumpt considers the modpath when grouping imports and we want to
      -- have the same behavior whether calling gofumpt from inside vim or from
      -- the cli, so we add the modpath manually
      gofumpt_source = null_ls.builtins.formatting.gofumpt.with({
        extra_args = { "-modpath", go_modpath },
      })
    end

    local function has_eslint_config()
      local results = vim.fs.find("eslint.config.mjs", { upward = true })
      if #results == 0 then
        return false
      end

      return true
    end

    null_ls.setup({
      sources = {
        -- formatting for python (linting is handled by ruff lsp itself)
        require("none-ls.formatting.ruff"),

        -- format typescript/html/css/vue
        null_ls.builtins.formatting.prettierd,

        -- lint typescript/html/css/vue
        -- eslint_d is from none-ls-extras so we have to use require here
        require("none-ls.diagnostics.eslint_d").with({ condition = has_eslint_config }),

        -- runs goimports and then formats while shortening long lines
        null_ls.builtins.formatting.golines,

        -- gofumpt does stricter formatting than gofmt
        -- unfortunately we cannot use it as a base formatter for golines
        -- https://github.com/segmentio/golines/issues/100
        -- so we run it afterwards and format the file twice
        gofumpt_source,

        null_ls.builtins.diagnostics.golangci_lint,

        -- format/autofix php files
        null_ls.builtins.formatting.phpcbf,

        -- format and lint twig templates
        null_ls.builtins.formatting.djlint.with({
          filetypes = { "twig" },
        }),
        null_ls.builtins.diagnostics.djlint.with({
          filetypes = { "twig" },
        }),

        -- bash scripts
        null_ls.builtins.formatting.shfmt,
      },
    })

    local typst_font_paths_env = os.getenv("TYPST_FONT_PATHS")
    local typst_font_paths = nil
    if typst_font_paths_env ~= nil then
      typst_font_paths = { typst_font_paths_env }
    end

    vim.lsp.config("tinymist", {
      settings = {
        formatterMode = "typstyle",
        exportPdf = "onType",
        semanticTokens = "disable",
        fontPaths = typst_font_paths,
      },
    })

    vim.lsp.config("lua_ls", {
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

    vim.lsp.enable({ "ty", "vtsls", "vue_ls", "gopls", "ruff", "phpactor", "tinymist", "lua_ls" })

    local lsp_signature = require("lsp_signature")
    lsp_signature.setup({
      bind = true,
      hint_enable = false,           -- disable virtual text hint
      doc_lines = 0,                 -- no doc lines, less noise
      handler_opts = {
        border = "none",             -- disable border so it matches the style of hover info
      },
      hi_parameter = "DoesNotExist", -- disable active parameter highlighting
    })
  end,
}

local telescope_spec = {
  "nvim-telescope/telescope.nvim",
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
    vim.cmd([[Lazy load markdown-preview.nvim]])
    vim.fn["mkdp#util#install"]()
  end,
}

require("lazy").setup({
  cmp_spec,
  treesitter_spec,
  markdown_preview_spec,
  telescope_spec,
  mason_spec,
  "justinmk/vim-dirvish",
  lspconfig_spec,
}, {
  change_detection = {
    notify = false,
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client.supports_method("textDocument/formatting", ev.buf) then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format()
        end,
      })
    end

    local nmap = function(keys, func)
      vim.keymap.set("n", keys, func, { buffer = ev.buf, noremap = true })
    end

    local vmap = function(keys, func)
      vim.keymap.set("v", keys, func, { buffer = ev.buf, noremap = true })
    end

    nmap("<leader>r", vim.lsp.buf.rename)
    nmap("<leader>a", vim.lsp.buf.code_action)
    nmap("<leader>e", vim.lsp.buf.hover)
    nmap("gD", vim.lsp.buf.declaration)
    nmap("gd", require("telescope.builtin").lsp_definitions)
    nmap("gr", require("telescope.builtin").lsp_references)
    nmap("gi", require("telescope.builtin").lsp_implementations)
    nmap("gy", require("telescope.builtin").lsp_type_definitions)
    vmap("<leader>a", vim.lsp.buf.code_action)
  end,
})

local local_file = vim.fn.stdpath("config") .. "/local.lua"
if vim.fn.filereadable(local_file) == 1 then
  dofile(local_file)
end
