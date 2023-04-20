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

local check = function ()
  if generateplugin_autocnt >= generateplugin_autoload_max_cnt then
    if generateplugin_autocmd then
      a.nvim_del_autocmd(generateplugin_autocmd)
    end
    generateplugin_loaded = true
  end
  if generateplugin_autocnt == 0 then
    generateplugin_loaded = true
  end
end

local generateplugin = function(params)
  if not generateplugin_loaded then
    check()
    sta, do_generateplugin = pcall(require, 'do_generateplugin')
    if not sta then
      print(do_generateplugin)
      return
    end
    if generateplugin_autocnt > 0 then
      return
    end
  end
  if not do_generateplugin then
    return
  end
  do_generateplugin.run(params)
end

generateplugin_autocmd = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost' }, {
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
s({ 'n', 'v' }, '<leader><leader><leader>z', ':GeneratePlugiN do<cr>', opt)
