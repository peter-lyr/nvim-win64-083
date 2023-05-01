local a = vim.api

-- local c = vim.cmd
-- local o = vim.opt

local g = vim.g
local f = vim.fn
g.transword_lua = f['expand']('<sfile>')

local sta

local do_transword
local transword_autocmd
local transword_loaded

-- package.loaded['do_transword'] = nil

local init = function()
  if not transword_loaded then
    transword_loaded = true
    sta, do_transword = pcall(require, 'do_transword')
    if not sta then
      print(do_transword)
      return nil
    end
  end
  if transword_autocmd then
    a.nvim_del_autocmd(transword_autocmd)
    transword_autocmd = nil
  end
  return true
end

local transword = function()
  if not init() then
    return
  end
  pcall(do_transword.run)
end


a.nvim_create_user_command('TransworD', function()
  transword()
end, { nargs = '*', })

local s = vim.keymap.set
local opt = { silent = true }
s({ 'n', 'v' }, 'tw', ':<c-u>TransworD<cr>', opt)
