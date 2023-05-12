local a = vim.api

local sta

local do_optiontoggle
local optiontoggle_autocmd

local optiontoggle_loaded = nil
-- package.loaded['do_optiontoggle'] = nil

local init = function()
  if not optiontoggle_loaded then
    optiontoggle_loaded = true
    sta, do_optiontoggle = pcall(require, 'do_optiontoggle')
    if not sta then
      print(do_optiontoggle)
      return nil
    end
  end
  if optiontoggle_autocmd then
    a.nvim_del_autocmd(optiontoggle_autocmd)
    optiontoggle_autocmd = nil
  end
  return true
end

local optiontoggle = function(params)
  if not init() then
    return
  end
  pcall(do_optiontoggle.run, params)
end


a.nvim_create_user_command('OptiontogglE', function(params)
  optiontoggle(params['fargs'])
end, { nargs = '*', })

local s = vim.keymap.set
local opt = { silent = true }
s({ 'n', 'v' }, '<leader>xw', ':<c-u>OptiontogglE wrap<cr>', opt)
