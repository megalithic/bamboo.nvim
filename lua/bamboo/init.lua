local M = {}

M.styles_list = { 'vulgaris', 'multiplex', 'light' }

---Change bamboo option (vim.g.bamboo_config.option)
---It can't be changed directly by modifying that field due to a Neovim lua bug with global variables (bamboo_config is a global variable)
---@param opt string: option name
---@param value any: new value
function M.set_options(opt, value)
  local cfg = vim.g.bamboo_config
  cfg[opt] = value
  vim.g.bamboo_config = cfg
end

---Apply the colorscheme (same as ':colorscheme bamboo')
function M.colorscheme()
  vim.cmd('hi clear')
  if vim.fn.exists('syntax_on') then
    vim.cmd('syntax reset')
  end
  vim.o.termguicolors = true
  vim.g.colors_name = 'bamboo'
  if vim.o.background == 'light' then
    M.set_options('style', 'light')
  elseif vim.g.bamboo_config.style == 'light' then
    M.set_options('style', 'vulgaris')
  end
  require('bamboo.highlights').setup()
  require('bamboo.terminal').setup()
end

---Toggle between bamboo styles
function M.toggle()
  local index = vim.g.bamboo_config.toggle_style_index + 1
  if index > #vim.g.bamboo_config.toggle_style_list then
    index = 1
  end
  M.set_options('style', vim.g.bamboo_config.toggle_style_list[index])
  M.set_options('toggle_style_index', index)
  if vim.g.bamboo_config.style == 'light' then
    vim.o.background = 'light'
  else
    vim.o.background = 'dark'
  end
end

local default_config = {
  -- Main options --
  style = 'vulgaris', -- choose between 'vulgaris' (regular), 'multiplex' (greener), and 'light'
  toggle_style_key = nil,
  toggle_style_list = M.styles_list,
  transparent = false, -- don't set background
  dim_inactive = false, -- don't dim inactive windows
  term_colors = true, -- if true enable the terminal
  ending_tildes = false, -- show the end-of-buffer tildes
  cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

  -- Changing Formats --
  code_style = {
    comments = 'italic',
    conditionals = 'italic',
    keywords = 'none',
    functions = 'none',
    namespaces = 'italic',
    parameters = 'italic',
    strings = 'none',
    variables = 'none',
  },

  -- Lualine options --
  lualine = {
    transparent = false, -- center bar (c) transparency
  },

  -- Custom Highlights --
  colors = {}, -- Override default colors
  highlights = {}, -- Override highlight groups

  -- Plugins Related --
  diagnostics = {
    darker = false, -- darker colors for diagnostic
    undercurl = true, -- use undercurl for diagnostics
    background = true, -- use background color for virtual text
  },
}

---Setup bamboo.nvim options, without applying colorscheme
---@param opts table?: a table containing options
function M.setup(opts)
  if not vim.g.bamboo_config or not vim.g.bamboo_config.loaded then -- if it's the first time setup() is called
    vim.g.bamboo_config =
      vim.tbl_deep_extend('keep', vim.g.bamboo_config or {}, default_config)
    M.set_options('loaded', true)
    M.set_options('toggle_style_index', 1)
  end
  if opts then
    vim.g.bamboo_config =
      vim.tbl_deep_extend('force', vim.g.bamboo_config, opts)
    if opts.toggle_style_list then -- this table cannot be extended, it has to be replaced
      M.set_options('toggle_style_list', opts.toggle_style_list)
    end
  end
  if vim.g.bamboo_config.toggle_style_key then
    vim.api.nvim_set_keymap(
      'n',
      vim.g.bamboo_config.toggle_style_key,
      '<cmd>lua require("bamboo").toggle()<cr>',
      { noremap = true, silent = true }
    )
  end
end

function M.load()
  vim.cmd('colorscheme bamboo')
end

return M
