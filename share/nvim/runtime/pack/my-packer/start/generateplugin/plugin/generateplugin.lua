local a = vim.api
local c = vim.cmd
local f = vim.fn
local g = vim.g
local s = vim.keymap.set

g.generateplugin_lua = f['expand']('<sfile>')

local generateplugin = function(params)
  if not g.generateplugin_loaded then
    g.generateplugin_loaded = 1
    a.nvim_del_autocmd(g.generateplugin_cursormoved)
    sta, do_generateplugin = pcall(require, 'do_generateplugin')
    if not sta then
      print("no do_generateplugin")
      return
    end
  end
  if not do_generateplugin then
    return
  end
  do_generateplugin.run(params)
end

if not g.generateplugin_startup then
  g.generateplugin_startup = 1
  g.generateplugin_cursormoved = a.nvim_create_autocmd({"CursorMoved"}, {
    callback = function()
      a.nvim_del_autocmd(g.generateplugin_cursormoved)
      generateplugin()
    end,
  })
end

a.nvim_create_user_command('GeneratePlugiN', function(params)
  generateplugin(params['fargs'])
end, { nargs = "*", })

local opt = {silent = true}

s({'n', 'v'}, '<leader><leader><leader>z', ':GeneratePlugiN do<cr>', opt)
