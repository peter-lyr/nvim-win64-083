local a = vim.api
local c = vim.cmd
local g = vim.g
local s = vim.keymap.set

local fugitive = function(cmd)
  if not g.fugitive_loaded then
    g.fugitive_loaded = 1
    local sta, packadd = pcall(c, 'packadd vim-fugitive')
    if not sta then
      print(packadd)
      return
    end
  end
  c(cmd)
end

a.nvim_create_user_command('FugitivE', function(params)
  fugitive(table.concat(params['fargs'], ' '))
end, { nargs = "*", })


local opt = { silent = true }

s({'n', 'v'}, '<leader>gg',  ":FugitivE Git<cr>", opt)
s({'n', 'v'}, '<leader>gA',  ":FugitivE Git add -A<cr>", opt)
s({'n', 'v'}, '<leader>ga',  ":FugitivE Git add %<cr>", opt)
