local a = vim.api

-- local c = vim.cmd
-- local o = vim.opt

local g = vim.g
local f = vim.fn
g.generateplugin_lua = f['expand']('<sfile>')

local sta

local do_generateplugin
local generateplugin_autocmd

local generateplugin_loaded = nil
-- package.loaded['do_generateplugin'] = nil

local init = function()
  if not generateplugin_loaded then
    generateplugin_loaded = true
    sta, do_generateplugin = pcall(require, 'do_generateplugin')
    if not sta then
      print(do_generateplugin)
      return nil
    end
  end
  if generateplugin_autocmd then
    a.nvim_del_autocmd(generateplugin_autocmd)
    generateplugin_autocmd = nil
  end
  return true
end

local generateplugin = function(params)
  if not init() then
    return
  end
  pcall(do_generateplugin.run, params)
end


-- generateplugin_autocmd = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
--   callback = function()
--     generateplugin()
--   end,
-- })


a.nvim_create_user_command('GeneratePlugiN', function(params)
  generateplugin(params['fargs'])
end, { nargs = '*', })

local s = vim.keymap.set
local opt = { silent = true }
s({ 'n', 'v' }, '<leader><leader><leader>z', ':<c-u>GeneratePlugiN do<cr>', opt)
