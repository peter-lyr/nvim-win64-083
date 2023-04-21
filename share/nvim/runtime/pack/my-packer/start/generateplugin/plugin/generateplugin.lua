local a = vim.api
local f = vim.fn
local g = vim.g

-- local c = vim.cmd
-- local o = vim.opt

local sta

local do_generateplugin = nil
local generateplugin_autocmd = nil
local generateplugin_autocnt = 0
local generateplugin_autoload_max_cnt = 1
local generateplugin_loaded = nil

g.generateplugin_lua = f['expand']('<sfile>')

local generateplugin = function(params)
  if not generateplugin_loaded then
    generateplugin_loaded = true
    sta, do_generateplugin = pcall(require, 'do_generateplugin')
    if not sta then
      print(do_generateplugin)
      return
    end
  end
  if generateplugin_autocnt >= generateplugin_autoload_max_cnt and generateplugin_autocmd then
    a.nvim_del_autocmd(generateplugin_autocmd)
  end
  if not do_generateplugin then
    return
  end
  do_generateplugin.run(params)
end

generateplugin_autocmd = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    generateplugin_autocnt = generateplugin_autocnt + 1
    generateplugin()
  end,
})

a.nvim_create_user_command('GeneratePlugiN', function(params)
  generateplugin(params['fargs'])
end, { nargs = '*', })


local s = vim.keymap.set
local opt = { silent = true }
s({ 'n', 'v' }, '<leader><leader><leader>z', ':<c-u>GeneratePlugiN do<cr>', opt)
