local a = vim.api
local f = vim.fn
local g = vim.g
local s = vim.keymap.set

local sta

g.netrw_lua = f['expand']('<sfile>')


local netrw = function(params)
  if not g.netrw_loaded then
    g.netrw_loaded = 1
    if g.netrw_cursormoved then
      a.nvim_del_autocmd(g.netrw_cursormoved)
    end
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

if not g.netrw_startup then
  g.netrw_startup = 1
  g.netrw_cursormoved = a.nvim_create_autocmd({ "BufNew" }, {
    callback = function()
      a.nvim_del_autocmd(g.netrw_cursormoved)
      netrw()
    end,
  })
end

a.nvim_create_user_command('NetrW', function(params)
  netrw(params['fargs'])
end, { nargs = "*", })


local opt = { silent = true }

s({ 'n', 'v' }, '<leader>l', ":NetrW toggle_fix<cr>", opt)
s({ 'n', 'v' }, '<leader><leader>l', ":NetrW fix_unfix<cr>", opt)
s({ 'n', 'v' }, '<leader>;', ":NetrW toggle_search_fname<cr>", opt)
s({ 'n', 'v' }, '<leader><leader>;', ":NetrW toggle_search_cwd<cr>", opt)
s({ 'n', 'v' }, '<leader>\'', ":NetrW toggle_search_sel<cr>", opt)
