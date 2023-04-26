local s = vim.keymap.set
local f = vim.fn
local g = vim.g
local c = vim.cmd

g.NERDSpaceDelims = 1
g.NERDDefaultAlign = "left"
g.NERDCommentEmptyLines = 1
g.NERDTrimTrailingWhitespace = 1
g.NERDToggleCheckAllLines = 1

g.NERDAltDelims_c = 1

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

if not add_pack_help({ 'nerdcommenter' }) then
  return nil
end


local opt = { silent = true }

s({ 'n', 'v' }, '<leader>cp', "vip:call nerdcommenter#Comment('x', 'toggle')<CR>", opt)
s({ 'n', 'v' }, '<leader>c}', "V}k:call nerdcommenter#Comment('x', 'toggle')<CR>", opt)
s({ 'n', 'v' }, '<leader>c{', "V{j:call nerdcommenter#Comment('x', 'toggle')<CR>", opt)
s({ 'n', 'v' }, '<leader>cG', "VG:call nerdcommenter#Comment('x', 'toggle')<CR>", opt)
