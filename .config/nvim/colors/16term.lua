if vim.g.colors_name then
  vim.cmd("hi clear")
end

vim.opt.background = "dark"
vim.g.colors_name = "16term"

local c = {
  none = "none",
  black = "black",
  darkblue = "darkblue",
  darkgreen = "darkgreen",
  darkcyan = "darkcyan",
  darkred = "darkred",
  darkmagenta = "darkmagenta",
  darkyellow = "darkyellow",
  gray = "gray",
  darkgray = "darkgray",
  blue = "blue",
  green = "green",
  cyan = "cyan",
  red = "red",
  magenta = "magenta",
  yellow = "yellow",
  white = "white",
}

local highlights = {
  ColorColumn = {},                                                        -- Columns set with 'colorcolumn'
  Conceal = {},                                                            -- Placeholder characters substituted for concealed text (see 'conceallevel')
  Cursor = {},                                                             -- Character under the cursor
  CurSearch = { ctermbg = c.yellow, ctermfg = c.black },                   -- Highlighting a search pattern under the cursor (see 'hlsearch')
  lCursor = {},                                                            -- Character under the cursor when |language-mapping| is used (see 'guicursor')
  CursorIM = {},                                                           -- Like Cursor, but used when in IME mode |CursorIM|
  CursorColumn = {},                                                       -- Screen-column at the cursor, when 'cursorcolumn' is set.
  CursorLine = {},                                                         -- Screen-line at the cursor, when 'cursorline' is set. Low-priority if foreground (ctermfg OR guifg) is not set.
  Directory = {},                                                          -- Directory names (and other special names in listings)
  DiffAdd = { ctermfg = c.green },                                         -- Diff mode: Added line |diff.txt|
  DiffChange = { ctermbg = c.magenta, ctermfg = c.black },                 -- Diff mode: Changed line |diff.txt|
  DiffDelete = { ctermfg = c.red },                                        -- Diff mode: Deleted line |diff.txt|
  DiffText = { ctermbg = c.magenta, ctermfg = c.white },                   -- Diff mode: Changed text within a changed line |diff.txt|
  EndOfBuffer = {},                                                        -- Filler lines (~) after the end of the buffer. By default, this is highlighted like |hl-NonText|.
  TermCursor = { cterm = { reverse = true } },                             -- Cursor in a focused terminal
  TermCursorNC = {},                                                       -- Cursor in an unfocused terminal
  ErrorMsg = { ctermfg = c.darkred },                                      -- Error messages on the command line
  VertSplit = {},                                                          -- Column separating vertically split windows
  Folded = {},                                                             -- Line used for closed folds
  FoldColumn = {},                                                         -- 'foldcolumn'
  SignColumn = { ctermbg = c.black },                                      -- Column where |signs| are displayed
  IncSearch = { ctermbg = c.yellow, ctermfg = c.black },                   -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
  Substitute = { ctermbg = c.yellow, ctermfg = c.black },                  -- |:substitute| replacement text highlighting
  LineNr = { ctermfg = c.darkgray, ctermbg = c.black },                    -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
  LineNrAbove = {},                                                        -- Line number for when the 'relativenumber' option is set, above the cursor line
  LineNrBelow = {},                                                        -- Line number for when the 'relativenumber' option is set, below the cursor line
  CursorLineNr = {},                                                       -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
  CursorLineFold = {},                                                     -- Like FoldColumn when 'cursorline' is set for the cursor line
  CursorLineSign = {},                                                     -- Like SignColumn when 'cursorline' is set for the cursor line
  MatchParen = { ctermfg = c.white, cterm = { bold = true } },             -- Character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
  ModeMsg = {},                                                            -- 'showmode' message (e.g., "-- INSERT -- ")
  MsgArea = {},                                                            -- Area for messages and cmdline
  MsgSeparator = {},                                                       -- Separator for scrolled messages, `msgsep` flag of 'display'
  MoreMsg = {},                                                            -- |more-prompt|
  NonText = {},                                                            -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
  Normal = {},                                                             -- Normal text
  NormalFloat = { ctermfg = c.darkgray, ctermbg = c.black },               -- Normal text in floating windows.
  FloatBorder = {},                                                        -- Border of floating windows.
  FloatTitle = {},                                                         -- Title of floating windows.
  NormalNC = {},                                                           -- normal text in non-current windows
  Pmenu = { ctermfg = c.gray, ctermbg = c.black },                         -- Popup menu: Normal item.
  PmenuSel = { ctermfg = c.cyan, ctermbg = c.black },                      -- Popup menu: Selected item.
  PmenuKind = {},                                                          -- Popup menu: Normal item "kind"
  PmenuKindSel = {},                                                       -- Popup menu: Selected item "kind"
  PmenuExtra = {},                                                         -- Popup menu: Normal item "extra text"
  PmenuExtraSel = {},                                                      -- Popup menu: Selected item "extra text"
  PmenuSbar = {},                                                          -- Popup menu: Scrollbar.
  PmenuThumb = {},                                                         -- Popup menu: Thumb of the scrollbar.
  Question = {},                                                           -- |hit-enter| prompt and yes/no questions
  QuickFixLine = {},                                                       -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
  Search = { ctermbg = c.yellow, ctermfg = c.black },                      -- Last search pattern highlighting (see 'hlsearch'). Also used for similar items that need to stand out.
  SpecialKey = {},                                                         -- Unprintable characters: text displayed differently from what it really is. But not 'listchars' whitespace. |hl-Whitespace|
  SpellBad = { cterm = { undercurl = true }, sp = c.red },                 -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
  SpellCap = {},                                                           -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
  SpellLocal = {},                                                         -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
  SpellRare = {},                                                          -- Word that is recognized by the spellchecker as one that is hardly ever used. |spell| Combined with the highlighting used otherwise.
  StatusLine = { ctermbg = c.black },                                      -- Status line of current window
  StatusLineNC = { ctermbg = c.darkgray },                                 -- Status lines of not-current windows. Note: If this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
  TabLine = {},                                                            -- Tab pages line, not active tab page label
  TabLineFill = {},                                                        -- Tab pages line, where there are no labels
  TabLineSel = {},                                                         -- Tab pages line, active tab page label
  Title = {},                                                              -- Titles for output from ":set all", ":autocmd" etc.
  Visual = { cterm = { reverse = true } },                                 -- Visual mode selection
  VisualNOS = {},                                                          -- Visual mode selection when vim is "Not Owning the Selection".
  WarningMsg = {},                                                         -- Warning messages
  Whitespace = {},                                                         -- "nbsp", "space", "tab" and "trail" in 'listchars'
  Winseparator = {},                                                       -- Separator between window splits. Inherts from |hl-VertSplit| by default, which it will replace eventually.
  WildMenu = { ctermbg = c.magenta },                                      -- Current match in 'wildmenu' completion
  WinBar = {},                                                             -- Window bar of current window
  WinBarNC = {},                                                           -- Window bar of not-current windows

  Comment = { ctermfg = c.darkgray },                                      -- Any comment

  Constant = { ctermfg = c.red },                                          -- (*) Any constant
  String = { ctermfg = c.green },                                          --   A string constant: "this is a string"
  Character = {},                                                          --   A character constant: 'c', '\n'
  Number = { ctermfg = c.red },                                            --   A number constant: 234, 0xff
  Boolean = {},                                                            --   A boolean constant: TRUE, false
  Float = {},                                                              --   A floating point constant: 2.3e10

  Identifier = {},                                                         -- (*) Any variable name
  Function = {},                                                           --   Function name (also: methods for classes)

  Statement = { ctermfg = c.blue },                                        -- (*) Any statement
  Conditional = { ctermfg = c.blue },                                      --   if, then, else, endif, switch, etc.
  Repeat = { ctermfg = c.blue },                                           --   for, do, while, etc.
  Label = { ctermfg = c.blue },                                            --   case, default, etc.
  Operator = {},                                                           --   "sizeof", "+", "*", etc.
  Keyword = { ctermfg = c.blue },                                          --   any other keyword
  Exception = {},                                                          --   try, catch, throw
  PreProc = {},                                                            -- (*) Generic Preprocessor
  Include = { link = "Keyword" },                                          --   Preprocessor #include
  Define = {},                                                             --   Preprocessor #define
  Macro = {},                                                              --   Same as Define
  PreCondit = {},                                                          --   Preprocessor #if, #else, #endif, etc.

  Type = { ctermfg = c.blue },                                             -- (*) int, long, char, etc.
  StorageClass = {},                                                       --   static, register, volatile, etc.
  Structure = {},                                                          --   struct, union, enum, etc.
  Typedef = {},                                                            --   A typedef

  Special = {},                                                            -- (*) Any special symbol
  SpecialChar = {},                                                        --   Special character in a constant
  Tag = {},                                                                --   You can use CTRL-] on this
  Delimiter = {},                                                          --   Character that needs attention
  SpecialComment = {},                                                     --   Special things inside a comment (e.g. '\n')
  Debug = {},                                                              --   Debugging statements

  Underlined = {},                                                         -- Text that stands out, HTML links
  Ignore = {},                                                             -- Left blank, hidden |hl-Ignore| (NOTE: May be invisible here in template)
  Error = { ctermfg = c.darkred },                                         -- Any erroneous construct
  Todo = {},                                                               -- Anything that needs extra attention; mostly the keywords TODO FIXME and XXX

  LspReferenceText = {},                                                   -- Used for highlighting "text" references
  LspReferenceRead = {},                                                   -- Used for highlighting "read" references
  LspReferenceWrite = {},                                                  -- Used for highlighting "write" references
  LspCodeLens = {},                                                        -- Used to color the virtual text of the codelens. See |nvim_buf_set_extmark()|.
  LspCodeLensSeparator = {},                                               -- Used to color the seperator between two or more code lens.
  LspSignatureActiveParameter = {},                                        -- Used to highlight the active parameter in the signature help. See |vim.lsp.handlers.signature_help()|.

  DiagnosticError = { ctermfg = c.red },                                   -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
  DiagnosticWarn = {},                                                     -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
  DiagnosticInfo = {},                                                     -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
  DiagnosticHint = {},                                                     -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
  DiagnosticOk = {},                                                       -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
  DiagnosticVirtualTextError = {},                                         -- Used for "Error" diagnostic virtual text.
  DiagnosticVirtualTextWarn = {},                                          -- Used for "Warn" diagnostic virtual text.
  DiagnosticVirtualTextInfo = {},                                          -- Used for "Info" diagnostic virtual text.
  DiagnosticVirtualTextHint = {},                                          -- Used for "Hint" diagnostic virtual text.
  DiagnosticVirtualTextOk = {},                                            -- Used for "Ok" diagnostic virtual text.
  DiagnosticUnderlineError = { cterm = { underline = true }, sp = c.red }, -- Used to underline "Error" diagnostics.
  DiagnosticUnderlineWarn = {},                                            -- Used to underline "Warn" diagnostics.
  DiagnosticUnderlineInfo = {},                                            -- Used to underline "Info" diagnostics.
  DiagnosticUnderlineHint = {},                                            -- Used to underline "Hint" diagnostics.
  DiagnosticUnderlineOk = {},                                              -- Used to underline "Ok" diagnostics.
  DiagnosticFloatingError = { ctermfg = c.darkred },                       -- Used to color "Error" diagnostic messages in diagnostics float. See |vim.diagnostic.open_float()|
  DiagnosticFloatingWarn = {},                                             -- Used to color "Warn" diagnostic messages in diagnostics float.
  DiagnosticFloatingInfo = {},                                             -- Used to color "Info" diagnostic messages in diagnostics float.
  DiagnosticFloatingHint = {},                                             -- Used to color "Hint" diagnostic messages in diagnostics float.
  DiagnosticFloatingOk = {},                                               -- Used to color "Ok" diagnostic messages in diagnostics float.
  DiagnosticSignError = { ctermfg = c.darkred, ctermbg = c.black },        -- Used for "Error" signs in sign column.
  DiagnosticSignWarn = { ctermfg = c.yellow, ctermbg = c.black },          -- Used for "Warn" signs in sign column.
  DiagnosticSignInfo = { ctermfg = c.blue, ctermbg = c.black },            -- Used for "Info" signs in sign column.
  DiagnosticSignHint = { ctermfg = c.gray, ctermbg = c.black },            -- Used for "Hint" signs in sign column.
  DiagnosticSignOk = {},                                                   -- Used for "Ok" signs in sign column.

  diffAdded = { ctermfg = c.green },
  diffRemoved = { ctermfg = c.darkred },

  ["@constant.builtin.go"] = { ctermfg = c.red },
  ["@string.regexp.typescript"] = { link = "String" },
  ["@lsp.type.class.vue"] = { link = "Normal" },

  AvanteConflictCurrentLabel = { ctermbg = c.black, cterm = { bold = true } },
  AvanteConflictCurrent = { ctermbg = c.black },
  AvanteConflictIncomingLabel = { ctermbg = 8, cterm = { bold = true } },
  AvanteConflictIncoming = { ctermbg = 8 },
}

for hl, spec in pairs(highlights) do
  vim.api.nvim_set_hl(0, hl, spec)
end
