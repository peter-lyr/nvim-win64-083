local f = vim.fn
local c = vim.cmd

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

if not add_pack_help({ 'vim-highlighter' }) then
  return nil
end

local a = vim.api
local o = vim.opt

local hista = nil

a.nvim_create_autocmd({ 'BufEnter' }, {
  callback = function()
    vim.schedule(function()
      if o.ft:get() == 'qf' then
        if f['highlighter#isfollowed']() == 1 then
          hista = true
          c('Hi -')
        end
      elseif hista then
        hista = nil
        c('Hi >>')
      end
    end)
  end,
})
