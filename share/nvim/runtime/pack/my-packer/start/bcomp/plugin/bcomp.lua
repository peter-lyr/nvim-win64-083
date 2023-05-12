local a = vim.api

local sta

local do_bcomp
local bcomp_autocmd

local bcomp_loaded = nil
-- package.loaded['do_bcomp'] = nil

local init = function()
  if not bcomp_loaded then
    bcomp_loaded = true
    sta, do_bcomp = pcall(require, 'do_bcomp')
    if not sta then
      print(do_bcomp)
      return nil
    end
  end
  if bcomp_autocmd then
    a.nvim_del_autocmd(bcomp_autocmd)
    bcomp_autocmd = nil
  end
  return true
end

local bcomp = function(params)
  if not init() then
    return
  end
  pcall(do_bcomp.run, params)
end


a.nvim_create_user_command('BcomP', function(params)
  bcomp(params['fargs'])
end, { nargs = '*', })

local s = vim.keymap.set
local opt = { silent = true }
s({ 'n', 'v' }, '<leader>b<f1>', ':<c-u>BcomP 1<cr>', opt)
s({ 'n', 'v' }, '<leader>b<f2>', ':<c-u>BcomP 2<cr>', opt)
s({ 'n', 'v' }, '<leader>b<f3>', ':<c-u>BcomP 3<cr>', opt)
