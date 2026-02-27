-- bloodcode.lua — A red-toned dark hacker colorscheme
-- Like The Matrix, but red.

vim.o.background = "dark"
vim.g.colors_name = "bloodcode"

local h = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ─── Palette ────────────────────────────────────────────────────────────────
local c = {
  -- Backgrounds
  NONE      = "NONE",
  bg0       = "#0e0a0a",  -- true bg (unused for Normal — transparent)
  bg1       = "#130d0e",  -- panels, floats
  bg2       = "#1c1214",  -- visual selection, cursorline
  bg3       = "#2a1b1e",  -- borders, fold

  -- Primary reds
  red       = "#ff2e3a",  -- primary accent, cursor, search match
  red_dim   = "#c21c28",  -- strings
  red_hi    = "#ff6270",  -- fg text, variables, identifiers

  -- Accents
  amber     = "#ffaf00",  -- secondary, headings, warnings
  gold      = "#f6c524",  -- operators, types
  magenta   = "#ff70c7",  -- keywords
  orange    = "#ffa83d",  -- numbers, constants
  violet    = "#bf4bff",  -- errors, builtins
  yellow    = "#ffe657",  -- types, bold, tags
  cyan      = "#30e5ff",  -- info, functions, links
  gray      = "#a3918c",  -- comments, muted, line numbers

  -- Diff
  diff_add_bg     = "#261316",
  diff_remove_bg  = "#1e1226",
  diff_add_fg     = "#ff97a3",
  diff_remove_fg  = "#d471ff",
}

-- ─── Editor Core ────────────────────────────────────────────────────────────
h("Normal",          { fg = c.red_hi,  bg = c.NONE })
h("NormalNC",        { fg = c.red_hi,  bg = c.NONE })
h("NormalFloat",     { fg = c.red_hi,  bg = c.bg1 })
h("SignColumn",      { fg = c.gray,    bg = c.NONE })
h("EndOfBuffer",     { fg = c.bg3,     bg = c.NONE })
h("LineNr",          { fg = c.gray,    bg = c.NONE })
h("CursorLineNr",    { fg = c.amber,   bg = c.NONE, bold = true })
h("CursorLine",      { bg = c.bg2 })
h("ColorColumn",     { bg = c.bg2 })
h("Cursor",          { fg = c.bg0,     bg = c.red })
h("lCursor",         { fg = c.bg0,     bg = c.red })
h("TermCursor",      { fg = c.bg0,     bg = c.red })
h("MatchParen",      { fg = c.yellow,  bg = c.bg3,  bold = true })
h("Visual",          { bg = c.bg2 })
h("VisualNOS",       { bg = c.bg2 })
h("Search",          { fg = c.bg0,     bg = c.red })
h("IncSearch",       { fg = c.bg0,     bg = c.amber })
h("CurSearch",       { fg = c.bg0,     bg = c.amber })
h("Substitute",      { fg = c.bg0,     bg = c.magenta })
h("NonText",         { fg = c.bg3 })
h("SpecialKey",      { fg = c.bg3 })
h("Conceal",         { fg = c.gray })
h("Directory",       { fg = c.cyan,    bold = true })
h("Title",           { fg = c.amber,   bold = true })

-- Status / Tab / Win
h("StatusLine",      { fg = c.red_hi,  bg = c.bg1 })
h("StatusLineNC",    { fg = c.gray,    bg = c.bg1 })
h("WinSeparator",    { fg = c.bg3 })
h("VertSplit",       { fg = c.bg3 })
h("WinBar",          { fg = c.amber,   bg = c.NONE, bold = true })
h("WinBarNC",        { fg = c.gray,    bg = c.NONE })
h("TabLine",         { fg = c.gray,    bg = c.bg1 })
h("TabLineFill",     { fg = c.gray,    bg = c.bg1 })
h("TabLineSel",      { fg = c.amber,   bg = c.bg2, bold = true })

-- Folds
h("Folded",          { fg = c.gray,    bg = c.bg3 })
h("FoldColumn",      { fg = c.gray,    bg = c.NONE })

-- Popup / Completion
h("Pmenu",           { fg = c.red_hi,  bg = c.bg1 })
h("PmenuSel",        { fg = c.bg0,     bg = c.red })
h("PmenuSbar",       { bg = c.bg2 })
h("PmenuThumb",      { bg = c.red_dim })
h("WildMenu",        { fg = c.bg0,     bg = c.amber })
h("FloatBorder",     { fg = c.red_dim, bg = c.bg1 })
h("FloatTitle",      { fg = c.amber,   bg = c.bg1, bold = true })

-- Messages
h("ErrorMsg",        { fg = c.violet })
h("WarningMsg",      { fg = c.amber })
h("ModeMsg",         { fg = c.gold,    bold = true })
h("MoreMsg",         { fg = c.cyan })
h("Question",        { fg = c.cyan })

-- Spell
h("SpellBad",        { undercurl = true, sp = c.red })
h("SpellCap",        { undercurl = true, sp = c.amber })
h("SpellLocal",      { undercurl = true, sp = c.cyan })
h("SpellRare",       { undercurl = true, sp = c.magenta })

-- ─── Syntax (Legacy) ────────────────────────────────────────────────────────
h("Comment",         { fg = c.gray,    italic = true })
h("Constant",        { fg = c.orange })
h("String",          { fg = c.red_dim })
h("Character",       { fg = c.red_dim })
h("Number",          { fg = c.orange })
h("Boolean",         { fg = c.orange })
h("Float",           { fg = c.orange })

h("Identifier",      { fg = c.red_hi })
h("Function",        { fg = c.cyan })

h("Statement",       { fg = c.magenta })
h("Conditional",     { fg = c.magenta })
h("Repeat",          { fg = c.magenta })
h("Label",           { fg = c.magenta })
h("Operator",        { fg = c.gold })
h("Keyword",         { fg = c.magenta, bold = true })
h("Exception",       { fg = c.violet })

h("PreProc",         { fg = c.amber })
h("Include",         { fg = c.amber })
h("Define",          { fg = c.amber })
h("Macro",           { fg = c.amber })
h("PreCondit",       { fg = c.amber })

h("Type",            { fg = c.yellow })
h("StorageClass",    { fg = c.yellow })
h("Structure",       { fg = c.yellow })
h("Typedef",         { fg = c.yellow })

h("Special",         { fg = c.red })
h("SpecialChar",     { fg = c.red })
h("Tag",             { fg = c.yellow })
h("Delimiter",       { fg = c.gray })
h("SpecialComment",  { fg = c.gray,    italic = true })
h("Debug",           { fg = c.violet })

h("Underlined",      { fg = c.cyan,    underline = true })
h("Ignore",          { fg = c.bg3 })
h("Error",           { fg = c.violet,  bold = true })
h("Todo",            { fg = c.bg0,     bg = c.amber, bold = true })

h("Added",           { fg = c.diff_add_fg })
h("Changed",         { fg = c.gold })
h("Removed",         { fg = c.diff_remove_fg })

-- ─── Treesitter ─────────────────────────────────────────────────────────────
-- Comments
h("@comment",                  { fg = c.gray,    italic = true })
h("@comment.documentation",    { fg = c.gray,    italic = true })

-- Keywords
h("@keyword",                  { fg = c.magenta, bold = true })
h("@keyword.return",           { fg = c.magenta, bold = true })
h("@keyword.function",         { fg = c.magenta, bold = true })
h("@keyword.operator",         { fg = c.gold })
h("@keyword.import",           { fg = c.amber })
h("@keyword.conditional",      { fg = c.magenta })
h("@keyword.repeat",           { fg = c.magenta })
h("@keyword.exception",        { fg = c.violet })
h("@keyword.coroutine",        { fg = c.magenta })
h("@keyword.modifier",         { fg = c.yellow })

-- Functions
h("@function",                 { fg = c.cyan })
h("@function.builtin",         { fg = c.violet })
h("@function.call",            { fg = c.cyan })
h("@function.macro",           { fg = c.amber })
h("@method",                   { fg = c.cyan })
h("@method.call",              { fg = c.cyan })

-- Variables
h("@variable",                 { fg = c.red_hi })
h("@variable.builtin",         { fg = c.violet })
h("@variable.parameter",       { fg = c.red_hi, italic = true })
h("@variable.member",          { fg = c.red_hi })

-- Strings
h("@string",                   { fg = c.red_dim })
h("@string.escape",            { fg = c.red })
h("@string.regex",             { fg = c.red })
h("@string.special",           { fg = c.red })
h("@string.documentation",     { fg = c.gray,    italic = true })

-- Literals
h("@number",                   { fg = c.orange })
h("@number.float",             { fg = c.orange })
h("@boolean",                  { fg = c.orange })
h("@character",                { fg = c.red_dim })
h("@character.special",        { fg = c.red })

-- Types
h("@type",                     { fg = c.yellow })
h("@type.builtin",             { fg = c.yellow })
h("@type.definition",          { fg = c.yellow })
h("@type.qualifier",           { fg = c.yellow })

-- Constants
h("@constant",                 { fg = c.orange })
h("@constant.builtin",         { fg = c.orange })
h("@constant.macro",           { fg = c.amber })

-- Operators / Punctuation
h("@operator",                 { fg = c.gold })
h("@punctuation.bracket",      { fg = c.gray })
h("@punctuation.delimiter",    { fg = c.gray })
h("@punctuation.special",      { fg = c.red })

-- Structure / Namespacing
h("@constructor",              { fg = c.yellow })
h("@namespace",                { fg = c.amber })
h("@module",                   { fg = c.amber })
h("@label",                    { fg = c.magenta })
h("@attribute",                { fg = c.amber })
h("@property",                 { fg = c.red_hi })
h("@field",                    { fg = c.red_hi })

-- Tags (HTML/JSX)
h("@tag",                      { fg = c.yellow })
h("@tag.attribute",            { fg = c.amber })
h("@tag.delimiter",            { fg = c.gray })

-- Markup / Markdown
h("@markup.heading",           { fg = c.amber,   bold = true })
h("@markup.bold",              { fg = c.yellow,  bold = true })
h("@markup.italic",            { fg = c.red_hi,  italic = true })
h("@markup.strikethrough",     { fg = c.gray,    strikethrough = true })
h("@markup.link",              { fg = c.cyan,    underline = true })
h("@markup.link.url",          { fg = c.cyan,    underline = true })
h("@markup.link.label",        { fg = c.cyan })
h("@markup.raw",               { fg = c.red_dim })
h("@markup.raw.block",         { fg = c.red_dim })
h("@markup.list",              { fg = c.red })
h("@markup.quote",             { fg = c.gray,    italic = true })

-- Diff (treesitter)
h("@diff.plus",                { fg = c.diff_add_fg })
h("@diff.minus",               { fg = c.diff_remove_fg })
h("@diff.delta",               { fg = c.gold })

-- ─── Diagnostics ────────────────────────────────────────────────────────────
h("DiagnosticError",                { fg = c.violet })
h("DiagnosticWarn",                 { fg = c.amber })
h("DiagnosticInfo",                 { fg = c.cyan })
h("DiagnosticHint",                 { fg = c.gray })

h("DiagnosticUnderlineError",       { undercurl = true, sp = c.violet })
h("DiagnosticUnderlineWarn",        { undercurl = true, sp = c.amber })
h("DiagnosticUnderlineInfo",        { undercurl = true, sp = c.cyan })
h("DiagnosticUnderlineHint",        { undercurl = true, sp = c.gray })

h("DiagnosticVirtualTextError",     { fg = c.violet,  bg = c.bg1 })
h("DiagnosticVirtualTextWarn",      { fg = c.amber,   bg = c.bg1 })
h("DiagnosticVirtualTextInfo",      { fg = c.cyan,    bg = c.bg1 })
h("DiagnosticVirtualTextHint",      { fg = c.gray,    bg = c.bg1 })

h("DiagnosticSignError",            { fg = c.violet })
h("DiagnosticSignWarn",             { fg = c.amber })
h("DiagnosticSignInfo",             { fg = c.cyan })
h("DiagnosticSignHint",             { fg = c.gray })

-- ─── Git / Diff ─────────────────────────────────────────────────────────────
h("DiffAdd",                 { fg = c.diff_add_fg,    bg = c.diff_add_bg })
h("DiffDelete",              { fg = c.diff_remove_fg, bg = c.diff_remove_bg })
h("DiffChange",              { fg = c.gold,           bg = c.bg2 })
h("DiffText",                { fg = c.bg0,            bg = c.gold })

-- GitSigns
h("GitSignsAdd",             { fg = c.diff_add_fg })
h("GitSignsChange",          { fg = c.gold })
h("GitSignsDelete",          { fg = c.diff_remove_fg })

-- GitGutter (legacy)
h("GitGutterAdd",            { fg = c.diff_add_fg })
h("GitGutterChange",         { fg = c.gold })
h("GitGutterDelete",         { fg = c.diff_remove_fg })

-- ─── Telescope ──────────────────────────────────────────────────────────────
h("TelescopeNormal",          { fg = c.red_hi,  bg = c.bg1 })
h("TelescopeBorder",          { fg = c.red_dim, bg = c.bg1 })
h("TelescopePromptNormal",    { fg = c.red_hi,  bg = c.bg2 })
h("TelescopePromptBorder",    { fg = c.red,     bg = c.bg2 })
h("TelescopePromptTitle",     { fg = c.bg0,     bg = c.red, bold = true })
h("TelescopePreviewTitle",    { fg = c.bg0,     bg = c.amber, bold = true })
h("TelescopeResultsTitle",    { fg = c.bg0,     bg = c.red_dim, bold = true })
h("TelescopeSelection",       { fg = c.red_hi,  bg = c.bg2 })
h("TelescopeMatching",        { fg = c.red,     bold = true })

-- ─── Neo-tree ───────────────────────────────────────────────────────────────
h("NeoTreeNormal",            { fg = c.red_hi,  bg = c.NONE })
h("NeoTreeNormalNC",          { fg = c.red_hi,  bg = c.NONE })
h("NeoTreeDirectoryName",     { fg = c.amber })
h("NeoTreeDirectoryIcon",     { fg = c.amber })
h("NeoTreeFileName",          { fg = c.red_hi })
h("NeoTreeGitAdded",          { fg = c.diff_add_fg })
h("NeoTreeGitModified",       { fg = c.gold })
h("NeoTreeGitDeleted",        { fg = c.diff_remove_fg })
h("NeoTreeIndentMarker",      { fg = c.bg3 })

-- ─── Indent Blankline ───────────────────────────────────────────────────────
h("IblIndent",                { fg = c.bg3 })
h("IblScope",                 { fg = c.red_dim })

-- ─── Notify ─────────────────────────────────────────────────────────────────
h("NotifyERRORBorder",        { fg = c.violet })
h("NotifyWARNBorder",         { fg = c.amber })
h("NotifyINFOBorder",         { fg = c.cyan })
h("NotifyDEBUGBorder",        { fg = c.gray })
h("NotifyTRACEBorder",        { fg = c.magenta })
h("NotifyERRORTitle",         { fg = c.violet,  bold = true })
h("NotifyWARNTitle",          { fg = c.amber,   bold = true })
h("NotifyINFOTitle",          { fg = c.cyan,    bold = true })
h("NotifyDEBUGTitle",         { fg = c.gray,    bold = true })
h("NotifyTRACETitle",         { fg = c.magenta, bold = true })

-- ─── Which-Key ──────────────────────────────────────────────────────────────
h("WhichKey",                 { fg = c.red })
h("WhichKeyGroup",            { fg = c.amber })
h("WhichKeyDesc",             { fg = c.red_hi })
h("WhichKeySeparator",        { fg = c.gray })
h("WhichKeyFloat",            { bg = c.bg1 })

-- ─── Mini ───────────────────────────────────────────────────────────────────
h("MiniStatuslineFilename",   { fg = c.red_hi, bg = c.bg2 })
h("MiniStatuslineDevinfo",    { fg = c.amber,  bg = c.bg2 })
h("MiniStatuslineFileinfo",   { fg = c.gray,   bg = c.bg2 })
h("MiniIndentscopeSymbol",    { fg = c.red_dim })

-- ─── Lazy.nvim ──────────────────────────────────────────────────────────────
h("LazyNormal",               { fg = c.red_hi, bg = c.bg1 })
h("LazyButton",               { fg = c.gray,   bg = c.bg2 })
h("LazyButtonActive",         { fg = c.bg0,    bg = c.red, bold = true })
