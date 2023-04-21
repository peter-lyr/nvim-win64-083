local f = vim.fn
local g = vim.g
local s = vim.keymap.set

local sta
local do_sdkcbp

g.sdkcbp_lua = f['expand']('<sfile>')

local sdkcbp_exe = function()
  if not g.loaded_do_sdkcbp then
    g.loaded_do_sdkcbp = 1
    sta, do_sdkcbp = pcall(require, 'do_sdkcbp')
    if not sta then
      print(do_sdkcbp)
      do_sdkcbp = nil
      return
    end
  end
  if not do_sdkcbp then
    print('no do_sdkcbp again')
    return
  end
  do_sdkcbp.run()
end

local opt = { silent = true }

s({ 'n', 'v' }, '<c-F9>', function() sdkcbp_exe() end, opt)
