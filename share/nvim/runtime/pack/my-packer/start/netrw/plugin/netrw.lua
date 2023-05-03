local a = vim.api
local f = vim.fn
local g = vim.g
local s = vim.keymap.set

local netrw_cursormoved = nil
local netrw_loaded = nil
-- package.loaded['do_netrw'] = nil

local sta

g.netrw_lua = f['expand']('<sfile>')


local netrw = function(params)
  if not netrw_loaded then
    netrw_loaded = 1
    a.nvim_del_autocmd(netrw_cursormoved)
    sta, Do_netrw = pcall(require, 'do_netrw')
    if not sta then
      print(Do_netrw)
      return
    end
  end
  if not Do_netrw then
    return
  end
  Do_netrw.run(params)
end

netrw_cursormoved = a.nvim_create_autocmd({ 'BufNew', 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    netrw()
  end,
})

a.nvim_create_user_command('NetrW', function(params)
  netrw(params['fargs'])
end, { nargs = '*', })


local opt = { silent = true }

s({ 'n', 'v' }, '<leader>l', ':<c-u>NetrW toggle_fix<cr>', opt)
s({ 'n', 'v' }, '<leader><leader>l', ':<c-u>NetrW fix_unfix<cr>', opt)
s({ 'n', 'v' }, '<leader>;', ':<c-u>NetrW toggle_search_fname<cr>', opt)
s({ 'n', 'v' }, '<leader><leader>;', ':<c-u>NetrW toggle_search_cwd<cr>', opt)
s({ 'n', 'v' }, '<leader>\'', ':<c-u>NetrW toggle_search_sel<cr>', opt)
