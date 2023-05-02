local a = vim.api

-- local c = vim.cmd
-- local o = vim.opt

local sta

local do_cinnamon
local cinnamon_autocmd
local cinnamon_loaded

-- package.loaded['do_cinnamon'] = nil

local init = function()
  if not cinnamon_loaded then
    cinnamon_loaded = true
    sta, do_cinnamon = pcall(require, 'do_cinnamon')
    if not sta then
      print(do_cinnamon)
      return nil
    end
  end
  if cinnamon_autocmd then
    a.nvim_del_autocmd(cinnamon_autocmd)
    cinnamon_autocmd = nil
  end
  return true
end

local cinnamon = function()
  if not init() then
    return
  end
end


cinnamon_autocmd = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    cinnamon()
  end,
})
