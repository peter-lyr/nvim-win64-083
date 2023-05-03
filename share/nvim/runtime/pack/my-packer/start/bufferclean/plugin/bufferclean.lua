local a = vim.api
local s = vim.keymap.set

local bufferclean_loaded = nil
local bufferclean_cursormoved = nil

local sta
local do_bufferclean

local bufferclean = function(params)
  if not bufferclean_loaded then
    bufferclean_loaded = 1
    a.nvim_del_autocmd(bufferclean_cursormoved)
    sta, do_bufferclean = pcall(require, 'do_bufferclean')
    if not sta then
      print(do_bufferclean)
      return
    end
  end
  if not do_bufferclean then
    return
  end
  do_bufferclean.run(params)
end

a.nvim_create_user_command('BuffercleaN', function(params)
  bufferclean(params['fargs'])
end, { nargs = '*', })

bufferclean_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    bufferclean()
  end,
})


local opt = { silent = true }

s({ 'n', 'v' }, '<leader>hh', ':<c-u>BuffercleaN cur<cr>', opt)
s({ 'n', 'v' }, '<leader><leader>hh', ':<c-u>BuffercleaN all<cr>', opt)
