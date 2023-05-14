local a = vim.api

local sta

local do_touchfileinfo
local touchfileinfo_autocmd

local touchfileinfo_loaded = nil
package.loaded['do_touchfileinfo'] = nil

local init = function()
  if not touchfileinfo_loaded then
    touchfileinfo_loaded = true
    sta, do_touchfileinfo = pcall(require, 'do_touchfileinfo')
    if not sta then
      print(do_touchfileinfo)
      return nil
    end
  end
  if touchfileinfo_autocmd then
    a.nvim_del_autocmd(touchfileinfo_autocmd)
    touchfileinfo_autocmd = nil
  end
  return true
end

local touchfileinfo = function(params)
  if not init() then
    return
  end
  pcall(do_touchfileinfo.run, params)
end


a.nvim_create_user_command('TouchfileinfO', function(params)
  touchfileinfo(params['fargs'])
end, { nargs = '*', })

local s = vim.keymap.set
local opt = { silent = true }
s({ 'n', 'v' }, '<leader><leader>ti', ':<c-u>TouchfileinfO create<cr>', opt)
