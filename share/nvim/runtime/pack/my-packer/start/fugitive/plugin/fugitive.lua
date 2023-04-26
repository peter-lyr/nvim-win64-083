local a = vim.api
local c = vim.cmd
local s = vim.keymap.set

local fugitive_cursormoved = nil
local fugitive_loaded = nil

local fugitive = function(cmd)
  if not fugitive_loaded then
    fugitive_loaded = 1
    a.nvim_del_autocmd(fugitive_cursormoved)
    local sta, do_fugitive = pcall(require, 'do_fugitive')
    if not sta then
      print(do_fugitive)
      return
    end
  end
  if not cmd or #cmd == 0 then
    return
  end
  c(cmd)
end

a.nvim_create_user_command('FugitivE', function(params)
  fugitive(table.concat(params['fargs'], ' '))
end, { nargs = '*', })

fugitive_cursormoved = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    fugitive()
  end,
})


local opt = { silent = true }

s({ 'n', 'v' }, '<leader>gg', ':<c-u>FugitivE Git<cr>', opt)
s({ 'n', 'v' }, '<leader>gA', ':<c-u>FugitivE Git add -A<cr>', opt)
s({ 'n', 'v' }, '<leader>ga', ':<c-u>FugitivE Git add %<cr>', opt)
