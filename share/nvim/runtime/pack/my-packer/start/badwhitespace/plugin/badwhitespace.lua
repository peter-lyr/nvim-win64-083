local a = vim.api
local s = vim.keymap.set

local badwhitespace_loaded = nil
local badwhitespace_cursormoved = nil

local sta
local do_badwhitespace

local badwhitespace = function(params)
  if not badwhitespace_loaded then
    badwhitespace_loaded = 1
    a.nvim_del_autocmd(badwhitespace_cursormoved)
    sta, do_badwhitespace = pcall(require, 'do_badwhitespace')
    if not sta then
      print(do_badwhitespace)
      return
    end
  end
  if not do_badwhitespace then
    return
  end
  do_badwhitespace.run(params)
end

a.nvim_create_user_command('BadwhitespacE', function(params)
  badwhitespace(params['fargs'])
end, { nargs = '*', })

badwhitespace_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    badwhitespace()
  end,
})


local opt = { silent = true }

s({ 'n', 'v' }, '<leader>ee', ':<c-u>BadwhitespacE Erase<cr>', opt)
s({ 'n', 'v' }, '<leader>eh', ':<c-u>BadwhitespacE Hide<cr> ', opt)
s({ 'n', 'v' }, '<leader>es', ':<c-u>BadwhitespacE Show<cr> ', opt)
