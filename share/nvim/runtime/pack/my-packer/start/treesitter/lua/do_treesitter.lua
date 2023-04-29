local c = vim.cmd
local f = vim.fn
local o = vim.opt

local sta

local add_pack_help = function(plugnames)
  local _sta, _path
  _sta, _path = pcall(require, "plenary.path")
  if not _sta then
    print(_path)
    return nil
  end
  local doc_path
  local packadd
  _path = _path:new(f.expand("$VIMRUNTIME"))
  local opt_path = _path:joinpath('pack', 'packer', 'opt')
  for _, plugname in ipairs(plugnames) do
    doc_path = opt_path:joinpath(plugname, 'doc')
    _sta, packadd = pcall(c, 'packadd ' .. plugname)
    if not _sta then
      print(packadd)
      return nil
    end
    if doc_path:is_dir() then
      c('helptags ' .. doc_path.filename)
    end
  end
  return true
end

if not add_pack_help({ 'nvim-treesitter' }) then
  return
end

local treesitter
sta, treesitter = pcall(require, "nvim-treesitter.configs")
if not sta then
  print(treesitter)
  return
end

add_pack_help({
  'nvim-treesitter-context',
})

if add_pack_help({
  'nvim-ts-rainbow',
}) then
  f['timer_start'](2000, require"rainbow.internal".defhl)
end

local parser_path = f.expand("$VIMRUNTIME") .. "\\my-neovim-data\\treesitter-parser"

o.runtimepath:append(parser_path)

treesitter.setup({
  ensure_installed = {}, -- 'all',
  sync_install = false,
  auto_install = false,
  parser_install_dir = parser_path,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    -- disable = {
    --   "markdown",
    --   "markdown_inline"
    -- },
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "qi",
      node_incremental = "qi",
      scope_incremental = "qu",
      node_decremental = "qo",
    },
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  }
})

local treesitter_context
sta, treesitter_context = pcall(require, "treesitter-context")
if not sta then
  print(treesitter_context)
  return
end
treesitter_context.setup({})
