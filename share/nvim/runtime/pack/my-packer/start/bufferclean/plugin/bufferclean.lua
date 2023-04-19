local a = vim.api
local f = vim.fn
local g = vim.g
local s = vim.keymap.set

local sta

g.bufferclean_lua = f['expand']('<sfile>')

local bufferclean = function(params)
  if not g.bufferclean_loaded then
    g.bufferclean_loaded = 1
    if g.bufferclean_cursormoved then
      a.nvim_del_autocmd(g.bufferclean_cursormoved)
    end
    sta, Do_bufferclean = pcall(require, 'do_bufferclean')
    if not sta then
      print(Do_bufferclean)
      return
    end
  end
  if not Do_bufferclean then
    return
  end
  Do_bufferclean.run(params)
end

a.nvim_create_user_command('BuffercleaN', function(params)
  bufferclean(params['fargs'])
end, { nargs = "*", })


local opt = { silent = true }

s({ 'n', 'v' }, '<leader>hh', ':BuffercleaN cur<cr>', opt)
s({ 'n', 'v' }, '<leader><leader>hh', ':BuffercleaN all<cr>', opt)
