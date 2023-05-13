local a = vim.api

local sta

local do_tablinesave
local tablinesave_autocmd

local tablinesave_loaded = nil
package.loaded['do_tablinesave'] = nil

local init = function()
  if not tablinesave_loaded then
    tablinesave_loaded = true
    sta, do_tablinesave = pcall(require, 'do_tablinesave')
    if not sta then
      print(do_tablinesave)
      return nil
    end
  end
  if tablinesave_autocmd then
    a.nvim_del_autocmd(tablinesave_autocmd)
    tablinesave_autocmd = nil
  end
  return true
end

local tablinesave = function(params)
  if not init() then
    return
  end
  pcall(do_tablinesave.run, params)
end


a.nvim_create_user_command('TablinesavE', function(params)
  tablinesave(params['fargs'])
end, { nargs = '*', })

local s = vim.keymap.set
local opt = { silent = true }
s({ 'n', 'v' }, '<leader>bT', ':<c-u>TablinesavE all<cr>', opt)
