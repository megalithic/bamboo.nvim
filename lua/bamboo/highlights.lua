local c = require('bamboo.colors')
local cfg = vim.g.bamboo_config
local util = require('bamboo.util')

local M = {}
local hl = { langs = {}, plugins = {} }

local function vim_highlights_nvim070(highlights)
  for group_name, group_settings in pairs(highlights) do
    ---@type (string | integer)[]
    local settings = {
      fg = group_settings.fg or 'none',
      bg = group_settings.bg or 'none',
      sp = group_settings.sp or 'none',
      link = group_settings.link or nil,
    }
    if group_settings.fmt and group_settings.fmt ~= 'none' then
      for _, setting in pairs(vim.split(group_settings.fmt, ',')) do
        settings[setting] = 1
      end
    end
    vim.api.nvim_set_hl(0, group_name, settings)
  end
end

local function vim_highlights_prior_to_nvim070(highlights)
  for group_name, group_settings in pairs(highlights) do
    if group_settings.link then
      vim.cmd(
        string.format('highlight! link %s %s', group_name, group_settings.link)
      )
    else
      vim.cmd(
        string.format(
          'highlight %s guifg=%s guibg=%s guisp=%s gui=%s',
          group_name,
          group_settings.fg or 'none',
          group_settings.bg or 'none',
          group_settings.sp or 'none',
          group_settings.fmt or 'none'
        )
      )
    end
  end
end

local vim_highlights = vim_highlights_prior_to_nvim070
if vim.fn.has('nvim-0.7.0') then
  vim_highlights = vim_highlights_nvim070
end

local colors = {
  Fg = { fg = c.fg },
  LightGrey = { fg = c.light_grey },
  Grey = { fg = c.grey },
  Red = { fg = c.red },
  Cyan = { fg = c.cyan },
  Yellow = { fg = c.yellow },
  Orange = { fg = c.orange },
  Green = { fg = c.green },
  Blue = { fg = c.blue },
  Purple = { fg = c.purple },
}

local normal_bg = cfg.transparent and c.none or c.bg0
local dimmable_bg = cfg.dim_inactive and util.darken(c.bg0, 0.125) or normal_bg
local light_blue = util.lighten(c.blue, 0.375)
local const_purple = util.blend(c.purple, c.orange, 0.25)
local light_purple = util.blend(c.purple, c.fg, 0.375)

hl.common = {
  Normal = { fg = c.fg, bg = normal_bg },
  NormalNC = {
    fg = cfg.dim_inactive and c.light_grey or c.fg,
    bg = dimmable_bg,
  },
  NormalFloat = { fg = c.fg, bg = dimmable_bg },
  FloatBorder = { fg = c.purple, bg = dimmable_bg },
  FloatTitle = colors.Red,
  FloatFooter = colors.LightGrey,
  Terminal = { fg = c.fg, bg = normal_bg },
  EndOfBuffer = { fg = cfg.ending_tildes and c.bg2 or c.bg0 },
  FoldColumn = { fg = c.fg },
  Folded = { fg = c.fg, bg = c.bg1 },
  SignColumn = { fg = c.fg },
  ToolbarLine = { fg = c.fg },
  Cursor = { fmt = 'reverse' },
  lCursor = { link = 'Cursor' },
  CursorIM = { link = 'Cursor' },
  CursorColumn = { link = 'CursorLine' },
  CursorLine = { bg = c.bg1 },
  ColorColumn = { bg = util.blend(c.bg1, c.green, 0.125) },
  CursorLineNr = { fg = c.fg },
  LineNr = { fg = c.grey },
  Conceal = { fg = c.grey },
  DiffAdd = { fg = c.none, bg = c.diff_add },
  DiffChange = { fg = c.none, bg = c.diff_change },
  DiffDelete = { fg = c.none, bg = c.diff_delete },
  DiffText = { fg = c.none, bg = c.diff_text },
  DiffAdded = colors.Green,
  DiffRemoved = colors.Red,
  DiffFile = colors.Cyan,
  DiffIndexLine = colors.Grey,
  Directory = { fg = c.blue },
  ErrorMsg = { fg = c.red, fmt = 'bold' },
  WarningMsg = { fg = c.yellow, fmt = 'bold' },
  MoreMsg = { fg = c.blue, fmt = 'bold' },
  CurSearch = { fg = c.bg0, bg = c.orange },
  IncSearch = { link = 'CurSearch' },
  Search = { fg = c.bg0, bg = c.bg_yellow },
  Substitute = { fg = c.bg0, bg = c.green },
  MatchParen = { fg = c.orange, bg = c.grey, fmt = 'bold' },
  NonText = { fg = c.grey },
  Whitespace = { link = 'NonText' },
  SpecialKey = { link = 'NonText' },
  Pmenu = { fg = c.fg, bg = c.bg1 },
  PmenuSbar = { fg = c.none, bg = c.bg1 },
  PmenuSel = { fg = c.bg0, bg = c.bg_blue },
  WildMenu = { fg = c.bg0, bg = c.blue },
  PmenuThumb = { fg = c.none, bg = c.grey },
  Question = { fg = c.yellow },
  SpellBad = { fg = c.none, fmt = 'undercurl', sp = c.red },
  SpellCap = { fg = c.none, fmt = 'undercurl', sp = c.yellow },
  SpellLocal = { fg = c.none, fmt = 'undercurl', sp = c.blue },
  SpellRare = { fg = c.none, fmt = 'undercurl', sp = c.purple },
  StatusLine = { fg = c.fg, bg = c.bg2 },
  StatusLineNC = { fg = c.grey, bg = c.bg1 },
  TabLine = { fg = c.fg, bg = c.bg1 },
  TabLineFill = { fg = c.grey, bg = c.bg1 },
  TabLineSel = { fg = c.bg0, bg = c.fg },
  VertSplit = { fg = c.bg3 },
  Title = { fg = c.cyan, fmt = 'bold' },
  Visual = { bg = c.bg3 },
  VisualNOS = { fg = c.none, bg = c.bg2, fmt = 'underline' },
  WinSeparator = { fg = c.bg3 },
  WinBar = { fg = c.coral },
  WinBarNC = { link = 'WinBar' },
  QuickFixLine = { fg = c.blue, fmt = 'underline' },
  Debug = { fg = c.orange },
  debugPC = { fg = c.bg0, bg = c.green },
  debugBreakpoint = { fg = c.bg0, bg = c.red },
  ToolbarButton = { fg = c.bg0, bg = c.bg_blue },
}

hl.syntax = {
  String = { fg = c.green, fmt = cfg.code_style.strings },
  Constant = colors.Orange,
  Character = { link = 'Constant' },
  Number = { link = 'Constant' },
  Float = { link = 'Constant' },
  Boolean = { link = 'Constant' },
  Type = colors.Yellow,
  Typedef = { link = 'Type' },
  Structure = { link = 'Type' },
  StorageClass = { fg = c.yellow, fmt = 'italic' },
  Identifier = { fg = c.red, fmt = cfg.code_style.variables },
  PreProc = colors.Purple,
  PreCondit = { link = 'PreProc' },
  Include = { link = 'PreProc' },
  Define = { link = 'PreProc' },
  Keyword = { fg = c.purple, fmt = cfg.code_style.keywords },
  Exception = { link = 'Keyword' },
  Conditional = { fg = c.purple, fmt = cfg.code_style.conditionals },
  Repeat = { link = 'Keyword' },
  Statement = colors.Purple,
  Macro = { fg = const_purple },
  Error = colors.Red,
  Label = { fg = c.red, fmt = 'bold' },
  Special = colors.Red,
  SpecialChar = { link = 'Special' },
  Function = { fg = c.blue, fmt = cfg.code_style.functions },
  Operator = { fg = light_purple },
  Tag = colors.Blue,
  Delimiter = colors.LightGrey,
  Comment = { fg = c.grey, fmt = cfg.code_style.comments },
  SpecialComment = { link = 'Comment' },
  Todo = { fg = c.black, bg = c.purple, fmt = 'bold' },

  Underlined = { fmt = 'underline' },
  Bold = { fmt = 'bold' },
  Italic = { fmt = 'italic' },
  Strike = { fmt = 'strikethrough' },
}

hl.treesitter = {
  ['@attribute'] = colors.Cyan,
  ['@attribute.typescript'] = colors.Blue,
  ['@boolean'] = { link = 'Boolean' },
  ['@character'] = { link = 'Character' },
  ['@character.special'] = { link = 'Special' },
  ['@comment'] = { fg = c.bg_yellow, fmt = cfg.code_style.comments },
  ['@comment.error'] = { fg = c.black, bg = c.red, fmt = 'bold' },
  ['@comment.note'] = { fg = c.black, bg = c.blue, fmt = 'bold' },
  ['@comment.todo'] = { link = 'Todo' },
  ['@comment.warning'] = { fg = c.black, bg = c.orange, fmt = 'bold' },
  ['@constant'] = { link = 'Constant' },
  ['@constant.builtin'] = { link = 'Constant' },
  ['@constant.macro'] = { link = 'Constant' },
  ['@constructor'] = { fg = c.yellow, fmt = 'bold' },
  ['@constructor.lua'] = { fg = c.yellow, fmt = 'none' },
  ['@diff.delta'] = { link = 'DiffChange' },
  ['@diff.minus'] = { link = 'DiffDelete' },
  ['@diff.plus'] = { link = 'DiffAdd' },
  ['@error'] = { link = 'Error' },
  ['@function'] = { link = 'Function' },
  ['@function.builtin'] = { fg = c.orange, fmt = cfg.code_style.functions },
  ['@function.call'] = { link = 'Function' },
  ['@function.macro'] = { fg = const_purple, fmt = cfg.code_style.functions },
  ['@function.method'] = { link = 'Function' },
  ['@function.method.call'] = { link = 'Function' },
  ['@keyword'] = { link = 'Keyword' },
  ['@keyword.conditional'] = { link = 'Conditional' },
  ['@keyword.conditional.ternary'] = { link = 'Operator' },
  ['@keyword.coroutine'] = { link = 'Keyword' },
  ['@keyword.debug'] = { link = 'Keyword' },
  ['@keyword.directive'] = { link = 'PreProc' },
  ['@keyword.directive.define'] = { fg = c.purple, fmt = 'bold' },
  ['@keyword.exception'] = { link = 'Exception' },
  ['@keyword.import'] = { link = 'Include' },
  ['@keyword.operator'] = { link = 'Keyword' },
  ['@keyword.repeat'] = { link = 'Repeat' },
  ['@keyword.return'] = { link = 'Keyword' },
  ['@keyword.storage'] = { link = 'StorageClass' },
  ['@label'] = { link = 'Label' },
  ['@markup.environment'] = { fg = c.cyan, fmt = 'bold' },
  ['@markup.environment.name'] = { link = 'Type' },
  ['@markup.heading'] = { fg = c.orange, fmt = 'bold' },
  ['@markup.heading.1'] = { fg = c.red, fmt = 'bold' },
  ['@markup.heading.1.marker'] = { link = '@markup.heading' },
  ['@markup.heading.2'] = { fg = c.yellow, fmt = 'bold' },
  ['@markup.heading.2.marker'] = { link = '@markup.heading' },
  ['@markup.heading.3'] = { fg = c.green, fmt = 'bold' },
  ['@markup.heading.3.marker'] = { link = '@markup.heading' },
  ['@markup.heading.4'] = { fg = c.cyan, fmt = 'bold' },
  ['@markup.heading.4.marker'] = { link = '@markup.heading' },
  ['@markup.heading.5'] = { fg = c.blue, fmt = 'bold' },
  ['@markup.heading.5.marker'] = { link = '@markup.heading' },
  ['@markup.heading.6'] = { fg = c.purple, fmt = 'bold' },
  ['@markup.heading.6.marker'] = { link = '@markup.heading' },
  ['@markup.italic'] = { fg = c.fg, fmt = 'italic' },
  ['@markup.italic.markdown_inline'] = { fg = c.orange, fmt = 'italic' },
  ['@markup.link'] = { link = 'Tag' },
  ['@markup.link.label'] = { link = 'Tag' },
  ['@markup.link.url'] = { fg = c.cyan, fmt = 'underline,italic' },
  ['@markup.list'] = { link = 'Special' },
  ['@markup.list.checked'] = { fg = c.yellow, fmt = 'bold' },
  ['@markup.list.unchecked'] = { fg = c.light_grey, fmt = 'bold' },
  ['@markup.math'] = { fg = light_blue },
  ['@markup.quote'] = { fg = util.blend(c.fg, c.light_grey, 0.5) },
  ['@markup.raw'] = colors.Green,
  ['@markup.raw.block'] = { link = '@markup.raw' },
  ['@markup.raw.delimiter'] = colors.LightGrey,
  ['@markup.strikethrough'] = { fg = c.fg, fmt = 'strikethrough' },
  ['@markup.strikethrough.markdown_inline'] = {
    fg = c.orange,
    fmt = 'strikethrough',
  },
  ['@markup.strong'] = { fg = c.fg, fmt = 'bold' },
  ['@markup.strong.markdown_inline'] = { fg = c.orange, fmt = 'bold' },
  ['@markup.underline'] = { fg = c.fg, fmt = 'underline' },
  ['@module'] = { fg = light_blue, fmt = cfg.code_style.namespaces },
  ['@module.builtin'] = { link = '@variable.builtin' },
  ['@none'] = colors.Fg,
  ['@number'] = { link = 'Number' },
  ['@number.float'] = { link = 'Float' },
  ['@operator'] = { link = 'Operator' },
  ['@property'] = { link = '@variable.member' },
  ['@punctuation.bracket'] = { link = 'Delimiter' },
  ['@punctuation.delimiter'] = { link = 'Delimiter' },
  ['@punctuation.special'] = { link = 'Special' },
  ['@string'] = { link = 'String' },
  ['@string.documentation'] = { link = '@comment' },
  ['@string.escape'] = { fg = c.coral },
  ['@string.regexp'] = { link = 'Constant' },
  ['@string.special'] = { link = 'Special' },
  ['@string.special.path'] = { fg = light_blue, fmt = 'underline' },
  ['@string.special.symbol'] = { link = '@variable.member' },
  ['@string.special.url'] = { fg = c.cyan, fmt = 'underline,italic' },
  ['@tag'] = colors.Purple,
  ['@tag.attribute'] = { link = '@variable.member' },
  ['@tag.builtin'] = { link = '@tag' },
  ['@tag.delimiter'] = { link = 'Delimiter' },
  ['@type'] = { link = 'Type' },
  ['@type.builtin'] = { link = 'Type' },
  ['@type.definition'] = { link = 'Type' },
  ['@type.qualifier'] = { fg = c.purple, fmt = 'italic' },
  ['@variable'] = { fg = c.fg, fmt = cfg.code_style.variables },
  ['@variable.builtin'] = { fg = c.red, fmt = cfg.code_style.variables },
  ['@variable.global'] = {
    fg = util.lighten(c.red, 0.375),
    fmt = cfg.code_style.variables,
  },
  ['@variable.member'] = colors.Cyan,
  ['@variable.parameter'] = { fg = c.coral, fmt = cfg.code_style.parameters },
  ['@variable.parameter.builtin'] = {
    fg = c.red,
    fmt = cfg.code_style.parameters,
  },
}

hl.lsp = {
  ['@lsp.mod.readonly'] = { link = '@constant' },
  -- workaround to get good static variable highlights in rust
  ['@lsp.mod.static.rust'] = { link = '@lsp.typemod.variable.static' },
  ['@lsp.mod.typeHint'] = { link = '@type' },
  ['@lsp.type.boolean'] = { link = '@boolean' },
  ['@lsp.type.builtinAttribute'] = { link = '@attribute' },
  ['@lsp.type.builtinConstant'] = { link = '@constant.builtin' },
  ['@lsp.type.builtinType'] = { link = '@type.builtin' },
  ['@lsp.type.class.markdown'] = {},
  -- disable comment highlighting, see the following issue:
  -- https://github.com/LuaLS/lua-language-server/issues/1809
  ['@lsp.type.comment'] = {},
  ['@lsp.type.decorator'] = { link = '@attribute' },
  ['@lsp.type.derive'] = { link = '@constructor' },
  ['@lsp.type.deriveHelper'] = { link = '@attribute' },
  ['@lsp.type.enum'] = { link = '@type' },
  ['@lsp.type.enumMember'] = { link = '@constant' },
  ['@lsp.type.escapeSequence'] = { link = '@string.escape' },
  ['@lsp.type.event'] = { link = 'Label' },
  ['@lsp.type.formatSpecifier'] = { link = '@punctuation.special' },
  ['@lsp.type.generic'] = { link = '@markup' },
  ['@lsp.type.interface'] = { link = '@type' },
  ['@lsp.type.keyword'] = { link = '@keyword' },
  ['@lsp.type.lifetime'] = { link = '@keyword.storage' },
  ['@lsp.type.macro'] = { link = 'Macro' },
  ['@lsp.type.magicFunction'] = { link = '@function.builtin' },
  ['@lsp.type.method'] = { link = '@function.method' },
  ['@lsp.type.namespace'] = { link = '@module' },
  ['@lsp.type.number'] = { link = '@number' },
  ['@lsp.type.operator'] = { link = '@operator' },
  -- don't highlight cpp operators, the LSP is too generous with these
  ['@lsp.type.operator.cpp'] = {},
  ['@lsp.type.parameter'] = { link = '@variable.parameter' },
  ['@lsp.type.property'] = { link = '@property' },
  ['@lsp.type.selfKeyword'] = { link = '@variable.builtin' },
  ['@lsp.type.selfTypeKeyword'] = { link = '@type' },
  ['@lsp.type.string'] = { link = '@string' },
  ['@lsp.type.typeAlias'] = { link = '@type.definition' },
  ['@lsp.type.typeParameter'] = { link = '@type' },
  ['@lsp.type.unresolvedReference'] = {
    [cfg.diagnostics.undercurl and 'undercurl' or 'underline'] = true,
    sp = c.red,
  },
  ['@lsp.type.variable'] = {}, -- use treesitter styles for regular variables
  -- ...except for rust, which benefits from this (the above is mostly only
  -- an issue with interpreted languages)
  ['@lsp.type.variable.rust'] = colors.Fg,
  ['@lsp.typemod.class.defaultLibrary'] = { link = '@type.builtin' },
  ['@lsp.typemod.enum.defaultLibrary'] = { link = '@type.builtin' },
  ['@lsp.typemod.enumMember.defaultLibrary'] = {
    link = '@constant.builtin',
  },
  ['@lsp.typemod.function.defaultLibrary'] = { link = '@function.builtin' },
  ['@lsp.typemod.function.readonly'] = { link = '@function.method' },
  -- For things like `#![allow(unused_variables, unused_mut)]` in Rust
  ['@lsp.typemod.generic.attribute'] = { link = '@keyword' },
  ['@lsp.typemod.keyword.async'] = { link = '@keyword.coroutine' },
  ['@lsp.typemod.keyword.injected'] = { link = '@keyword' },
  ['@lsp.typemod.macro.defaultLibrary'] = { link = '@function.builtin' },
  ['@lsp.typemod.method.defaultLibrary'] = { link = '@function.builtin' },
  ['@lsp.typemod.method.readonly'] = { link = '@function.method' },
  ['@lsp.typemod.method.static.rust'] = { link = '@function' },
  ['@lsp.typemod.operator.injected'] = { link = '@operator' },
  ['@lsp.typemod.parameter.mutable'] = {
    fg = util.blend(c.coral, c.purple, 0.2),
  },
  ['@lsp.typemod.parameter.readonly'] = {
    fg = util.blend(c.coral, c.yellow, 0.375),
  },
  ['@lsp.typemod.property.readonly'] = {
    fg = util.blend(c.cyan, c.green, 0.5),
  },
  ['@lsp.typemod.string.injected'] = { link = '@string' },
  ['@lsp.typemod.struct.defaultLibrary'] = { link = '@type.builtin' },
  ['@lsp.typemod.type.defaultLibrary'] = { link = '@type.builtin' },
  ['@lsp.typemod.typeAlias.defaultLibrary'] = { link = '@type.builtin' },
  ['@lsp.typemod.variable.callable'] = { link = '@function' },
  ['@lsp.typemod.variable.constant.rust'] = { link = '@constant' },
  ['@lsp.typemod.variable.defaultLibrary'] = { link = '@variable.builtin' },
  ['@lsp.typemod.variable.global'] = { link = '@variable.global' },
  ['@lsp.typemod.variable.injected'] = { link = '@variable' },
  ['@lsp.typemod.variable.mutable'] = { fg = util.blend(c.fg, c.green, 0.375) },
  ['@lsp.typemod.variable.static'] = { fg = light_blue },
  ['@lsp.typemod.variable.static.rust'] = {},
}

hl.treesitter.TreesitterContext = { bg = c.bg1 }

local diagnostics_error_color = cfg.diagnostics.darker and c.dark_red or c.red
local diagnostics_hint_color = cfg.diagnostics.darker and c.dark_purple
  or c.purple
local diagnostics_warn_color = cfg.diagnostics.darker and c.dark_yellow
  or c.yellow
local diagnostics_info_color = cfg.diagnostics.darker and c.dark_cyan or c.cyan
hl.plugins.lsp = {
  LspCxxHlGroupEnumConstant = colors.Orange,
  LspCxxHlGroupMemberVariable = colors.Orange,
  LspCxxHlGroupNamespace = colors.Blue,
  LspCxxHlSkippedRegion = colors.Grey,
  LspCxxHlSkippedRegionBeginEnd = colors.Red,

  DiagnosticUnnecessary = { link = 'Comment' },
  DiagnosticError = { fg = c.red },
  DiagnosticHint = { fg = c.purple },
  DiagnosticInfo = { fg = c.cyan },
  DiagnosticWarn = { fg = c.yellow },

  DiagnosticVirtualTextError = {
    bg = cfg.diagnostics.background
        and util.darken(diagnostics_error_color, 0.9, c.bg0)
      or c.none,
    fg = diagnostics_error_color,
  },
  DiagnosticVirtualTextWarn = {
    bg = cfg.diagnostics.background
        and util.darken(diagnostics_warn_color, 0.9, c.bg0)
      or c.none,
    fg = diagnostics_warn_color,
  },
  DiagnosticVirtualTextInfo = {
    bg = cfg.diagnostics.background
        and util.darken(diagnostics_info_color, 0.9, c.bg0)
      or c.none,
    fg = diagnostics_info_color,
  },
  DiagnosticVirtualTextHint = {
    bg = cfg.diagnostics.background
        and util.darken(diagnostics_hint_color, 0.9, c.bg0)
      or c.none,
    fg = diagnostics_hint_color,
  },

  DiagnosticUnderlineError = {
    fmt = cfg.diagnostics.undercurl and 'undercurl' or 'underline',
    sp = c.red,
  },
  DiagnosticUnderlineHint = {
    fmt = cfg.diagnostics.undercurl and 'undercurl' or 'underline',
    sp = c.purple,
  },
  DiagnosticUnderlineInfo = {
    fmt = cfg.diagnostics.undercurl and 'undercurl' or 'underline',
    sp = c.blue,
  },
  DiagnosticUnderlineWarn = {
    fmt = cfg.diagnostics.undercurl and 'undercurl' or 'underline',
    sp = c.yellow,
  },

  LspReferenceText = { bg = c.bg2 },
  LspReferenceWrite = { bg = c.bg2 },
  LspReferenceRead = { bg = c.bg2 },

  LspCodeLens = { link = 'Comment' },
  LspCodeLensSeparator = { fg = c.grey },
  LspInfoBorder = { link = 'FloatBorder' },
}

hl.plugins.lsp.LspDiagnosticsDefaultError = hl.plugins.lsp.DiagnosticError
hl.plugins.lsp.LspDiagnosticsDefaultHint = hl.plugins.lsp.DiagnosticHint
hl.plugins.lsp.LspDiagnosticsDefaultInformation = hl.plugins.lsp.DiagnosticInfo
hl.plugins.lsp.LspDiagnosticsDefaultWarning = hl.plugins.lsp.DiagnosticWarn
hl.plugins.lsp.LspDiagnosticsUnderlineError =
  hl.plugins.lsp.DiagnosticUnderlineError
hl.plugins.lsp.LspDiagnosticsUnderlineHint =
  hl.plugins.lsp.DiagnosticUnderlineHint
hl.plugins.lsp.LspDiagnosticsUnderlineInformation =
  hl.plugins.lsp.DiagnosticUnderlineInfo
hl.plugins.lsp.LspDiagnosticsUnderlineWarning =
  hl.plugins.lsp.DiagnosticUnderlineWarn
hl.plugins.lsp.LspDiagnosticsVirtualTextError =
  hl.plugins.lsp.DiagnosticVirtualTextError
hl.plugins.lsp.LspDiagnosticsVirtualTextWarning =
  hl.plugins.lsp.DiagnosticVirtualTextWarn
hl.plugins.lsp.LspDiagnosticsVirtualTextInformation =
  hl.plugins.lsp.DiagnosticVirtualTextInfo
hl.plugins.lsp.LspDiagnosticsVirtualTextHint =
  hl.plugins.lsp.DiagnosticVirtualTextHint

hl.plugins.ale = {
  ALEErrorSign = hl.plugins.lsp.DiagnosticError,
  ALEInfoSign = hl.plugins.lsp.DiagnosticInfo,
  ALEWarningSign = hl.plugins.lsp.DiagnosticWarn,
}

hl.plugins.barbar = {
  BufferCurrent = { fmt = 'bold' },
  BufferCurrentMod = { fg = c.orange, fmt = 'bold,italic' },
  BufferCurrentSign = { fg = c.purple },
  BufferInactiveMod = { fg = c.light_grey, bg = c.bg1, fmt = 'italic' },
  BufferVisible = { fg = c.light_grey, bg = c.bg0 },
  BufferVisibleMod = { fg = c.yellow, bg = c.bg0, fmt = 'italic' },
  BufferVisibleIndex = { fg = c.light_grey, bg = c.bg0 },
  BufferVisibleSign = { fg = c.light_grey, bg = c.bg0 },
  BufferVisibleTarget = { fg = c.light_grey, bg = c.bg0 },
}

hl.plugins.cmp = {
  CmpItemAbbr = colors.Fg,
  CmpItemAbbrDeprecated = { fg = c.light_grey, fmt = 'strikethrough' },
  CmpItemAbbrMatch = colors.Cyan,
  CmpItemAbbrMatchFuzzy = { fg = c.cyan, fmt = 'underline' },
  CmpItemMenu = colors.LightGrey,
  CmpItemKind = { fg = c.purple, fmt = cfg.cmp_itemkind_reverse and 'reverse' },
  CmpItemKindCopilot = {
    fg = c.fg,
    fmt = cfg.cmp_itemkind_reverse and 'reverse',
  },
  CmpItemKindCodeium = {
    fg = c.fg,
    fmt = cfg.cmp_itemkind_reverse and 'reverse',
  },
  CmpItemKindTabNine = {
    fg = c.fg,
    fmt = cfg.cmp_itemkind_reverse and 'reverse',
  },
}

hl.plugins.coc = {
  CocErrorSign = hl.plugins.lsp.DiagnosticError,
  CocHintSign = hl.plugins.lsp.DiagnosticHint,
  CocInfoSign = hl.plugins.lsp.DiagnosticInfo,
  CocWarningSign = hl.plugins.lsp.DiagnosticWarn,
}

hl.plugins.whichkey = {
  WhichKey = colors.Red,
  WhichKeyDesc = colors.Blue,
  WhichKeyGroup = colors.Orange,
  WhichKeySeparator = colors.Green,
}

hl.plugins.gitgutter = {
  GitGutterAdd = { fg = c.green },
  GitGutterChange = { fg = c.blue },
  GitGutterDelete = { fg = c.red },
}

hl.plugins.hop = {
  HopNextKey = { fg = c.red, fmt = 'bold' },
  HopNextKey1 = { fg = c.cyan, fmt = 'bold' },
  HopNextKey2 = { fg = util.darken(c.blue, 0.3) },
  HopUnmatched = colors.Grey,
}

hl.plugins.diffview = {
  DiffviewCursorLine = { link = 'CursorLine' },
  DiffviewEndOfBuffer = { link = 'EndOfBuffer' },
  DiffviewFilePanelCounter = { fg = c.purple, fmt = 'bold' },
  DiffviewFilePanelDeletions = colors.Red,
  DiffviewFilePanelFileName = colors.Fg,
  DiffviewFilePanelInsertions = colors.Green,
  DiffviewFilePanelPath = colors.Grey,
  DiffviewFilePanelRootPath = colors.Grey,
  DiffviewFilePanelTitle = { fg = c.blue, fmt = 'bold' },
  DiffviewHash = { link = 'Constant' },
  DiffviewNormal = { link = 'Normal' },
  DiffviewSignColumn = { link = 'SignColumn' },
  DiffviewStatusAdded = colors.Green,
  DiffviewStatusBroken = colors.Red,
  DiffviewStatusCopied = colors.Blue,
  DiffviewStatusDeleted = colors.Red,
  DiffviewStatusLine = { link = 'StatusLine' },
  DiffviewStatusLineNC = { link = 'StatusLineNC' },
  DiffviewStatusModified = colors.Blue,
  DiffviewStatusRenamed = colors.Blue,
  DiffviewStatusTypeChange = colors.Blue,
  DiffviewStatusUnknown = colors.Red,
  DiffviewStatusUnmerged = colors.Blue,
  DiffviewStatusUntracked = colors.Yellow,
  DiffviewVertSplit = { link = 'VertSplit' },
}

hl.plugins.gitsigns = {
  GitSignsAdd = colors.Green,
  GitSignsAddLn = colors.Green,
  GitSignsAddNr = colors.Green,
  GitSignsChange = colors.Blue,
  GitSignsChangeLn = colors.Blue,
  GitSignsChangeNr = colors.Blue,
  GitSignsDelete = colors.Red,
  GitSignsDeleteLn = colors.Red,
  GitSignsDeleteNr = colors.Red,
  GitSignsUntracked = colors.Yellow,
  GitSignsUntrackedLn = colors.Yellow,
  GitSignsUntrackedNr = colors.Yellow,
}

hl.plugins.lazy = {
  LazyReasonColorscheme = { fg = light_blue },
  LazyReasonCmd = colors.Green,
  LazyReasonFt = colors.Yellow,
  LazyReasonSource = colors.Blue,
  LazyReasonStart = { fg = c.cyan, fmt = 'bold' },
  LazyReasonTask = { fg = c.light_grey, fmt = 'bold' },
  LazyH2 = { fg = c.blue, fmt = 'bold' },
  -- Lazy requires a late Neovim version, so this is OK.
  LazyUrl = { link = '@string.special.url' },
}

hl.plugins.neo_tree = {
  NeoTreeNormal = { fg = c.fg, bg = cfg.transparent and c.none or c.bg_d },
  NeoTreeNormalNC = { fg = c.fg, bg = cfg.transparent and c.none or c.bg_d },
  NeoTreeVertSplit = { fg = c.bg1, bg = cfg.transparent and c.none or c.bg1 },
  NeoTreeWinSeparator = { fg = c.bg1, bg = cfg.transparent and c.none or c.bg1 },
  NeoTreeEndOfBuffer = {
    fg = cfg.ending_tildes and c.bg2 or c.bg_d,
    bg = cfg.transparent and c.none or c.bg_d,
  },
  NeoTreeRootName = { fg = c.orange, fmt = 'bold' },
  NeoTreeGitAdded = colors.Green,
  NeoTreeGitDeleted = colors.Red,
  NeoTreeGitModified = colors.Yellow,
  NeoTreeGitConflict = { fg = c.red, fmt = 'bold,italic' },
  NeoTreeGitUntracked = { fg = c.red, fmt = 'italic' },
  NeoTreeIndentMarker = colors.Grey,
  NeoTreeSymbolicLinkTarget = colors.Purple,
  NeoTreeTitleBar = { fg = c.bg0, bg = c.purple },
  NeoTreeFloatTitle = { link = 'FloatTitle' },
  NeoTreeFloatBorder = { link = 'FloatBorder' },
}

hl.plugins.neotest = {
  NeotestAdapterName = { fg = c.purple, fmt = 'bold' },
  NeotestDir = colors.Cyan,
  NeotestExpandMarker = colors.Grey,
  NeotestFailed = colors.Red,
  NeotestFile = colors.Cyan,
  NeotestFocused = { fmt = 'bold,italic' },
  NeotestIndent = colors.Grey,
  NeotestMarked = { fg = c.orange, fmt = 'bold' },
  NeotestNamespace = colors.Blue,
  NeotestPassed = colors.Green,
  NeotestRunning = colors.Yellow,
  NeotestWinSelect = { fg = c.cyan, fmt = 'bold' },
  NeotestSkipped = colors.LightGrey,
  NeotestTarget = colors.Purple,
  NeotestTest = colors.Fg,
  NeotestUnknown = colors.LightGrey,
}

hl.plugins.nvim_tree = {
  NvimTreeNormal = { fg = c.fg, bg = normal_bg },
  NvimTreeVertSplit = { fg = c.bg_d, bg = cfg.transparent and c.none or c.bg_d },
  NvimTreeRootFolder = { fg = c.orange, fmt = 'bold' },
  NvimTreeGitDirty = colors.Yellow,
  NvimTreeGitNew = colors.Green,
  NvimTreeGitDeleted = colors.Red,
  NvimTreeSpecialFile = { fg = c.yellow, fmt = 'underline' },
  NvimTreeSignColumn = { fmt = 'nocombine' },
  NvimTreeIndentMarker = colors.Fg,
  NvimTreeImageFile = { fg = c.dark_purple },
  NvimTreeFolderName = colors.Blue,
  NvimTreeOpenedFile = { fg = c.coral, fmt = 'bold,italic' },
}

hl.plugins.telescope = {
  TelescopeBorder = colors.Red,
  TelescopePromptBorder = colors.Purple,
  TelescopeResultsBorder = colors.Purple,
  TelescopePreviewBorder = colors.Purple,
  TelescopeMatching = { fg = c.orange, fmt = 'bold' },
  TelescopePromptPrefix = colors.Green,
  TelescopeSelection = { bg = c.bg2 },
  TelescopeSelectionCaret = { fg = c.orange, bg = c.bg2, fmt = 'bold' },
}

hl.plugins.dashboard = {
  DashboardShortCut = colors.Blue,
  DashboardHeader = colors.Yellow,
  DashboardCenter = colors.Cyan,
  DashboardFooter = { fg = c.dark_red, fmt = 'italic' },
  DashboardMruTitle = colors.Cyan,
  DashboardProjectTitle = colors.Cyan,
  DashboardFiles = colors.Fg,
  DashboardKey = colors.Orange,
  DashboardDesc = colors.Purple,
  DashboardIcon = colors.Purple,
}

hl.plugins.outline = {
  FocusedSymbol = { fg = c.purple, bg = c.bg2, fmt = 'bold' },
  AerialLine = { fg = c.purple, bg = c.bg2, fmt = 'bold' },
}

hl.plugins.navic = {
  NavicText = { fg = c.fg },
  NavicSeparator = { fg = c.light_grey },
}

hl.plugins.ts_rainbow = {
  rainbowcol1 = colors.Red,
  rainbowcol2 = colors.Yellow,
  rainbowcol3 = colors.Blue,
  rainbowcol4 = colors.Orange,
  rainbowcol5 = { fg = util.blend(c.green, c.fg, 0.375) },
  rainbowcol6 = colors.Purple,
  rainbowcol7 = colors.Cyan,
}

hl.plugins.ts_rainbow2 = {
  TSRainbowRed = { link = 'rainbowcol1' },
  TSRainbowYellow = { link = 'rainbowcol2' },
  TSRainbowBlue = { link = 'rainbowcol3' },
  TSRainbowOrange = { link = 'rainbowcol4' },
  TSRainbowGreen = { link = 'rainbowcol5' },
  TSRainbowViolet = { link = 'rainbowcol6' },
  TSRainbowCyan = { link = 'rainbowcol7' },
}

hl.plugins.rainbow_delimiters = {
  RainbowDelimiterRed = { link = 'rainbowcol1' },
  RainbowDelimiterYellow = { link = 'rainbowcol2' },
  RainbowDelimiterBlue = { link = 'rainbowcol3' },
  RainbowDelimiterOrange = { link = 'rainbowcol4' },
  RainbowDelimiterGreen = { link = 'rainbowcol5' },
  RainbowDelimiterViolet = { link = 'rainbowcol6' },
  RainbowDelimiterCyan = { link = 'rainbowcol7' },
}

hl.plugins.indent_blankline = {
  IndentBlanklineIndent1 = colors.Blue,
  IndentBlanklineIndent2 = colors.Green,
  IndentBlanklineIndent3 = colors.Cyan,
  IndentBlanklineIndent4 = colors.LightGrey,
  IndentBlanklineIndent5 = colors.Purple,
  IndentBlanklineIndent6 = colors.Red,
  IndentBlanklineChar = { fg = c.bg1, fmt = 'nocombine' },
  IndentBlanklineContextChar = { fg = c.light_grey, fmt = 'nocombine' },
  IndentBlanklineContextStart = { bg = c.bg1 },
  IndentBlanklineContextSpaceChar = { fmt = 'nocombine' },
  IblIndent = { fg = c.grey, fmt = 'nocombine' },
  IblScope = { fg = c.light_grey, fmt = 'nocombine' },
  IblWhitespace = { fg = c.grey, fmt = 'nocombine' },
}

hl.plugins.mini = {
  MiniCompletionActiveParameter = { fmt = 'underline' },

  MiniCursorword = { fmt = 'underline' },
  MiniCursorwordCurrent = { fmt = 'underline' },

  MiniIndentscopeSymbol = { fg = c.light_grey },
  MiniIndentscopePrefix = { fmt = 'nocombine' }, -- Make it invisible

  MiniJump = { fg = c.purple, fmt = 'underline', sp = c.purple },

  MiniJump2dSpot = { fg = c.red, fmt = 'bold,nocombine' },

  MiniStarterCurrent = { fmt = 'nocombine' },
  MiniStarterFooter = { fg = c.dark_red, fmt = 'italic' },
  MiniStarterHeader = colors.Yellow,
  MiniStarterInactive = { fg = c.grey, fmt = cfg.code_style.comments },
  MiniStarterItem = { fg = c.fg, bg = normal_bg },
  MiniStarterItemBullet = { fg = c.grey },
  MiniStarterItemPrefix = { fg = c.yellow },
  MiniStarterSection = colors.LightGrey,
  MiniStarterQuery = { fg = c.cyan },

  MiniStatuslineDevinfo = { fg = c.fg, bg = c.bg2 },
  MiniStatuslineFileinfo = { fg = c.fg, bg = c.bg2 },
  MiniStatuslineFilename = { fg = c.grey, bg = c.bg1 },
  MiniStatuslineInactive = { fg = c.grey, bg = c.bg0 },
  MiniStatuslineModeCommand = { fg = c.bg0, bg = c.yellow, fmt = 'bold' },
  MiniStatuslineModeInsert = { fg = c.bg0, bg = c.blue, fmt = 'bold' },
  MiniStatuslineModeNormal = { fg = c.bg0, bg = c.green, fmt = 'bold' },
  MiniStatuslineModeOther = { fg = c.bg0, bg = c.cyan, fmt = 'bold' },
  MiniStatuslineModeReplace = { fg = c.bg0, bg = c.red, fmt = 'bold' },
  MiniStatuslineModeVisual = { fg = c.bg0, bg = c.purple, fmt = 'bold' },

  MiniSurround = { fg = c.bg0, bg = c.orange },

  MiniTablineCurrent = { fmt = 'bold' },
  MiniTablineFill = { fg = c.grey, bg = c.bg1 },
  MiniTablineHidden = { fg = c.fg, bg = c.bg1 },
  MiniTablineModifiedCurrent = { fg = c.orange, fmt = 'bold,italic' },
  MiniTablineModifiedHidden = { fg = c.light_grey, bg = c.bg1, fmt = 'italic' },
  MiniTablineModifiedVisible = { fg = c.yellow, bg = c.bg0, fmt = 'italic' },
  MiniTablineTabpagesection = { fg = c.bg0, bg = c.bg_yellow },
  MiniTablineVisible = { fg = c.light_grey, bg = c.bg0 },

  MiniTestEmphasis = { fmt = 'bold' },
  MiniTestFail = { fg = c.red, fmt = 'bold' },
  MiniTestPass = { fg = c.green, fmt = 'bold' },

  MiniTrailspace = { bg = c.red },
}

hl.plugins.notify = {
  NotifyBackground = { bg = c.bg0 },
  NotifyERRORBorder = { link = 'DiagnosticError' },
  NotifyWARNBorder = { link = 'DiagnosticWarn' },
  NotifyINFOBorder = { link = 'DiagnosticInfo' },
  NotifyHINTBorder = { link = 'DiagnosticHint' },
  NotifyDEBUGBorder = { link = 'Debug' },
  NotifyTRACEBorder = { link = 'Comment' },
  NotifyERRORIcon = { link = 'DiagnosticError' },
  NotifyWARNIcon = { link = 'DiagnosticWarn' },
  NotifyINFOIcon = { link = 'DiagnosticInfo' },
  NotifyHINTIcon = { link = 'DiagnosticHint' },
  NotifyDEBUGIcon = { link = 'Debug' },
  NotifyTRACEIcon = { link = 'Comment' },
  NotifyERRORTitle = { link = 'DiagnosticError' },
  NotifyWARNTitle = { link = 'DiagnosticWarn' },
  NotifyINFOTitle = { link = 'DiagnosticInfo' },
  NotifyHINTTitle = { link = 'DiagnosticHint' },
  NotifyDEBUGTitle = { link = 'Debug' },
  NotifyTRACETitle = { link = 'Comment' },
}

hl.plugins.matchup = {
  MatchWord = { fmt = 'underline' },
}

hl.langs.c = {
  cInclude = colors.Blue,
  cStorageClass = colors.Purple,
  cTypedef = colors.Purple,
  cDefine = colors.Cyan,
}

hl.langs.cpp = {
  cppStatement = { fg = c.purple, fmt = 'bold' },
}

hl.langs.markdown = {
  markdownBlockquote = { link = 'Special' },
  markdownBold = { fg = c.none, fmt = 'bold' },
  markdownBoldDelimiter = { link = 'Delimiter' },
  markdownCode = colors.Green,
  markdownCodeBlock = colors.Green,
  markdownCodeDelimiter = colors.Yellow,
  markdownH1 = { fg = c.red, fmt = 'bold' },
  markdownH2 = { fg = c.yellow, fmt = 'bold' },
  markdownH3 = { fg = c.green, fmt = 'bold' },
  markdownH4 = { fg = c.cyan, fmt = 'bold' },
  markdownH5 = { fg = c.blue, fmt = 'bold' },
  markdownH6 = { fg = c.purple, fmt = 'bold' },
  markdownHeadingDelimiter = colors.Orange,
  markdownHeadingRule = colors.Orange,
  markdownId = colors.Yellow,
  markdownIdDeclaration = colors.Red,
  markdownItalic = { fg = c.none, fmt = 'italic' },
  markdownItalicDelimiter = { fg = c.light_grey, fmt = 'italic' },
  markdownLinkDelimiter = { link = 'Delimiter' },
  markdownLinkText = colors.Blue,
  markdownLinkTextDelimiter = { link = 'Delimiter' },
  markdownListMarker = colors.Red,
  markdownOrderedListMarker = colors.Red,
  markdownRule = colors.Purple,
  markdownUrl = { fg = c.cyan, fmt = 'underline' },
  markdownUrlDelimiter = { link = 'Delimiter' },
  markdownUrlTitleDelimiter = colors.Green,
}

hl.langs.php = {
  phpFunctions = { fg = c.fg, fmt = cfg.code_style.functions },
  phpMethods = colors.Cyan,
  phpStructure = colors.Purple,
  phpMemberSelector = colors.Fg,
  phpVarSelector = { fg = c.orange, fmt = cfg.code_style.variables },
  phpIdentifier = { fg = c.orange, fmt = cfg.code_style.variables },
  phpBoolean = colors.Cyan,
  phpHereDoc = colors.Green,
  phpNowDoc = colors.Green,
  phpSCKeyword = { fg = c.purple, fmt = cfg.code_style.keywords },
  phpFCKeyword = { fg = c.purple, fmt = cfg.code_style.keywords },
  phpRegion = colors.Blue,
}

hl.langs.scala = {
  scalaNameDefinition = colors.Fg,
  scalaInterpolationBoundary = colors.Purple,
  scalaInterpolation = colors.Purple,
  scalaTypeOperator = colors.Red,
  scalaOperator = colors.Red,
  scalaKeywordModifier = { fg = c.red, fmt = cfg.code_style.keywords },
}

hl.langs.tex = {
  texCmdEnv = colors.Cyan,
  texEnvArgName = colors.Yellow,
  texMathZoneX = colors.Orange,
  texMathZoneXX = colors.Orange,
  texMathDelimZone = colors.LightGrey,
  texMathDelim = colors.Purple,
  texMathOper = colors.Red,
  texCmd = colors.Purple,
  texCmdPart = colors.Blue,
  texCmdPackage = colors.Blue,
  texPgfType = colors.Yellow,
}

hl.langs.vim = {
  vimOption = colors.Red,
  vimSetEqual = colors.Yellow,
  vimMap = colors.Purple,
  vimMapModKey = colors.Orange,
  vimNotation = colors.Red,
  vimMapLhs = colors.Fg,
  vimMapRhs = colors.Blue,
  vimVar = { fg = c.fg, fmt = cfg.code_style.variables },
  vimCommentTitle = { fg = c.yellow, fmt = cfg.code_style.comments },
}

local lsp_kind_icons_color = {
  Default = c.purple,
  Array = c.yellow,
  Boolean = c.orange,
  Class = c.yellow,
  Color = c.green,
  Constant = c.orange,
  Constructor = c.blue,
  Enum = c.yellow,
  EnumMember = c.orange,
  Event = c.yellow,
  Field = c.cyan,
  File = c.green,
  Folder = light_blue,
  Function = c.blue,
  Interface = c.green,
  Key = c.cyan,
  Keyword = c.purple,
  Method = c.blue,
  Module = light_blue,
  Namespace = light_blue,
  Null = c.grey,
  Number = c.orange,
  Object = c.red,
  Operator = light_purple,
  Package = c.yellow,
  Property = c.cyan,
  Reference = c.orange,
  Snippet = const_purple,
  String = c.green,
  Struct = c.yellow,
  Text = c.light_grey,
  TypeParameter = c.coral,
  Unit = c.yellow,
  Value = c.orange,
  Variable = c.red,
}

function M.setup()
  -- define cmp and aerial kind highlights with lsp_kind_icons_color
  for kind, color in pairs(lsp_kind_icons_color) do
    hl.plugins.cmp['CmpItemKind' .. kind] = {
      fg = color,
      fmt = cfg.cmp_itemkind_reverse and 'reverse',
    }
    hl.plugins.outline['Aerial' .. kind .. 'Icon'] = { fg = color }
    hl.plugins.navic['NavicIcons' .. kind] = { fg = color }
  end
  -- custom, specific overrides
  hl.plugins.cmp['CmpItemKindSnippet'].fmt = cfg.cmp_itemkind_reverse
      and 'italic,reverse'
    or 'italic'

  vim_highlights(hl.common)
  vim_highlights(hl.syntax)
  vim_highlights(hl.treesitter)
  if hl.lsp then
    for k in pairs(hl.lsp) do
      vim.api.nvim_set_hl(0, k, hl.lsp[k])
    end
  end
  for _, group in pairs(hl.langs) do
    vim_highlights(group)
  end
  for _, group in pairs(hl.plugins) do
    vim_highlights(group)
  end

  -- user defined highlights: vim_highlights function cannot be used because it sets an attribute to none if not specified
  local function replace_color(prefix, color_name)
    if not color_name then
      return ''
    end
    if color_name:sub(1, 1) == '$' then
      local name = color_name:sub(2, -1)
      color_name = c[name]
      if not color_name then
        vim.schedule(function()
          vim.notify(
            'bamboo.nvim: unknown color "' .. name .. '"',
            vim.log.levels.ERROR,
            { title = 'bamboo.nvim' }
          )
        end)
        return ''
      end
    end
    return prefix .. '=' .. color_name
  end

  for group_name, group_settings in pairs(vim.g.bamboo_config.highlights) do
    if group_settings.link then
      vim.cmd(
        string.format('highlight! link %s %s', group_name, group_settings.link)
      )
    else
      vim.cmd(
        string.format(
          'highlight %s %s %s %s %s',
          group_name,
          replace_color('guifg', group_settings.fg),
          replace_color('guibg', group_settings.bg),
          replace_color('guisp', group_settings.sp),
          replace_color('gui', group_settings.fmt)
        )
      )
    end
  end
end

return M
