local a = vim.api

local sta

local do_multilinesearch
local multilinesearch_autocmd

local multilinesearch_loaded = nil
package.loaded['do_multilinesearch'] = nil

local init = function()
  if not multilinesearch_loaded then
    multilinesearch_loaded = true
    sta, do_multilinesearch = pcall(require, 'do_multilinesearch')
    if not sta then
      print(do_multilinesearch)
      return nil
    end
  end
  if multilinesearch_autocmd then
    a.nvim_del_autocmd(multilinesearch_autocmd)
    multilinesearch_autocmd = nil
  end
  return true
end

local multilinesearch = function(params)
  if not init() then
    return
  end
  pcall(do_multilinesearch.run, params)
end


a.nvim_create_user_command('MultilinesearcH', function(params)
  multilinesearch(params['fargs'])
end, { nargs = '*', })

local s = vim.keymap.set
local opt = { silent = true }
s({ 'n', 'v' }, '<c-8>', ':<c-u>MultilinesearcH do<cr>', opt)
