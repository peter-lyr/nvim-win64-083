local s = vim.keymap.set
local a = vim.api
local g = vim.g

local sta

local tortoisesvn_exe = function(cmd, root, yes)
  if not g.loaded_do_tortoisesvn then
    g.loaded_do_tortoisesvn = 1
    sta, Do_tortoisesvn = pcall(require, 'do_tortoisesvn')
    if not sta then
      print(Do_tortoisesvn)
      return
    end
  end
  if not Do_tortoisesvn then
    return
  end
  Do_tortoisesvn.run(cmd, root, yes)
end

a.nvim_create_user_command('TortoisesvN', function(params)
  tortoisesvn_exe(unpack(params['fargs']))
end, { nargs = "*", })


local opt = { silent = true }

s({ 'n', 'v' }, '<leader>vo', ':TortoisesvN settings cur yes<cr>', opt)

s({ 'n', 'v' }, '<leader>vd', ':TortoisesvN diff cur yes<cr>', opt)
s({ 'n', 'v' }, '<leader>vD', ':TortoisesvN diff root yes<cr>', opt)

s({ 'n', 'v' }, '<leader>vb', ':TortoisesvN blame cur yes<cr>', opt)

s({ 'n', 'v' }, '<leader>vw', ':TortoisesvN repobrowser cur yes<cr>', opt)
s({ 'n', 'v' }, '<leader>vW', ':TortoisesvN repobrowser root yes<cr>', opt)

s({ 'n', 'v' }, '<leader>vs', ':TortoisesvN repostatus cur yes<cr>', opt)
s({ 'n', 'v' }, '<leader>vS', ':TortoisesvN repostatus root yes<cr>', opt)

s({ 'n', 'v' }, '<leader>vr', ':TortoisesvN rename cur yes<cr>', opt)

s({ 'n', 'v' }, '<leader>vR', ':TortoisesvN remove cur yes<cr>', opt)

s({ 'n', 'v' }, '<leader>vv', ':TortoisesvN revert cur yes<cr>', opt)
s({ 'n', 'v' }, '<leader>vV', ':TortoisesvN revert root yes<cr>', opt)

s({ 'n', 'v' }, '<leader>va', ':TortoisesvN add cur yes<cr>', opt)
s({ 'n', 'v' }, '<leader>vA', ':TortoisesvN add root yes<cr>', opt)

s({ 'n', 'v' }, '<leader>vc', ':TortoisesvN commit cur yes<cr>', opt)
s({ 'n', 'v' }, '<leader>vC', ':TortoisesvN commit root yes<cr>', opt)

s({ 'n', 'v' }, '<leader>vu', ':TortoisesvN update root no<cr>', opt)
s({ 'n', 'v' }, '<leader>vU', ':TortoisesvN update /rev root yes<cr>', opt)

s({ 'n', 'v' }, '<leader>vl', ':TortoisesvN log cur yes<cr>', opt)
s({ 'n', 'v' }, '<leader>vL', ':TortoisesvN log root yes<cr>', opt)

s({ 'n', 'v' }, '<leader>vk', ':TortoisesvN checkout root yes<cr>', opt)
