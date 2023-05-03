local a = vim.api

local sta

local do_nvimexe
local nvimexe_autocmd

local nvimexe_loaded = nil
package.loaded['do_nvimexe'] = nil

local init = function()
  if not nvimexe_loaded then
    nvimexe_loaded = true
    sta, do_nvimexe = pcall(require, 'do_nvimexe')
    if not sta then
      print(do_nvimexe)
      return nil
    end
  end
  if nvimexe_autocmd then
    a.nvim_del_autocmd(nvimexe_autocmd)
    nvimexe_autocmd = nil
  end
  return true
end

local nvimexe = function(params)
  if not init() then
    return
  end
  pcall(do_nvimexe.run, params)
end


nvimexe_autocmd = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    nvimexe()
  end,
})


a.nvim_create_user_command('NvimexE', function(params)
  nvimexe(params['fargs'])
end, { nargs = '*', })

local s = vim.keymap.set
local opt = { silent = true }
s({ 'n', 'v' }, '<F6><del>', ':<c-u>NvimexE restart<cr>', opt)
