local c = vim.cmd
local a = vim.api
local f = vim.fn
local o = vim.opt
local g = vim.g

o.showtabline = 2

g.startuptime = os.time()
g.tabline_lua = vim.fn['expand']('<sfile>')

local set_tabline = nil

set_tabline = a.nvim_create_autocmd({ 'CursorMoved' }, {
  callback = function()
    a.nvim_del_autocmd(set_tabline)
    c([[set tabline=%!tabline#tabline()]])
  end,
})

-- package.loaded['do_tabline'] = nil

local sta, do_tabline
a.nvim_create_autocmd({ 'WinLeave' }, {
  callback = function()
    if not do_tabline then
      sta, do_tabline = pcall(require, 'do_tabline')
      if not sta then
        print('no do_tabline')
        return
      end
    end
    f['timer_start'](100, do_tabline.update_title_string)
  end,
})


local s = vim.keymap.set

local opt = { silent = true }

s({ 'n', 'v' }, '<leader>bs', ':<c-u>call tabline#restorehiddenprojects()<cr>', opt)
s({ 'n', 'v' }, '<leader>bt', ':<c-u>call tabline#savesession()<cr>', opt)
s({ 'n', 'v' }, '<leader>bu', ':<c-u>call tabline#restoresession()<cr>', opt)
s({ 'n', 'v' }, '<leader>bv', ':<c-u>call tabline#toggleshowtabline()<cr>', opt)
s({ 'n', 'v' }, '<leader>bz', ':<c-u>call tabline#bwothers()<cr>', opt)
