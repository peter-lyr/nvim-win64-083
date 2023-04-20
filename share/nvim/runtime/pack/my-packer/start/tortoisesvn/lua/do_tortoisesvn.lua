local M = {}

local sta, Path = pcall(require, "plenary.path")
if not sta then
  print(Path)
  return
end

local f = vim.fn
local a = vim.api

local index_of = function(arr, val)
  if not arr then
    return nil
  end
  for i, v in ipairs(arr) do
    if v == val then
      return i
    end
  end
  return nil
end

local system_cd_string = function(absfolder)
  local path = Path:new(absfolder)
  if not path:exists() then
    return ''
  end
  if path:is_file() then
    return string.sub(absfolder, 1, 1) .. ': && cd ' .. absfolder
  end
  return string.sub(absfolder, 1, 1) .. ': && cd ' .. path:parent()['filename']
end

function M.run(cmd, root, yes)
  if not cmd then
    return
  end
  local path = (root == 'root') and f['projectroot#get'](a['nvim_buf_get_name'](0)) or a['nvim_buf_get_name'](0)
  if yes == 'yes' or index_of({ 'y', 'Y' }, f['trim'](f['input']("Sure to update? [Y/n]: ", 'Y'))) then
    f['execute'](string.format("silent !%s && start tortoiseproc.exe /command:%s /path:\"%s\"", system_cd_string(path),
      cmd, path))
  end
end

local s = vim.keymap.set

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

return M
