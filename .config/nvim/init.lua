require("user.options")
require("user.keymaps")
require("user.lazy")

-- run golangci-lint after saving go files
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.go",
  callback = function()
    local filename = vim.fn.expand("%:p")

    -- run golangci-lint only on the current file with auto-fix
    local output = vim.fn.systemlist(string.format("golangci-lint run --fix --fast --out-format json %s", filename))

    -- we need to reload the file because `golangci-lint --fix` changes the file in-place
    -- when reloading the file, the line on which the cursor was before the reload is centered so the view 'jumps'
    -- to counter that, we restore the view after reloading the file
    local view = vim.fn.winsaveview()
    vim.cmd("edit")
    vim.fn.winrestview(view)

    -- TODO: to get more diagnostics here without freezing the ui we could run golangci-lint without --fast here asynchronously and the show the returned diagnostics. if the user saves againg while this command is running, we abort it.

    -- parse the output of golangci-lint
    local success, lint_data = pcall(vim.fn.json_decode, table.concat(output, "\n"))
    if not success then
      vim.notify("failed to parse golangci-lint output", vim.log.levels.ERROR)
      return
    end

    -- show diagnostics
    local diagnostics = {}

    if lint_data and lint_data.Issues then
      for _, issue in ipairs(lint_data.Issues) do
        table.insert(diagnostics, {
          lnum = issue.Pos.Line - 1, -- nvim uses 0-based indexing
          col = issue.Pos.Column - 1, -- nvim uses 0-based indexing
          severity = vim.diagnostic.severity.WARN,
          message = issue.Text,
          source = issue.FromLinter,
        })
      end
    end

    local namespace = vim.api.nvim_create_namespace("golangci-lint")

    vim.diagnostic.set(namespace, 0, diagnostics)
  end,
})

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
vim.cmd("iabbrev newvue <script setup lang='ts'></script><template></template>")

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

vim.cmd("set spelllang=de")

require("local")
