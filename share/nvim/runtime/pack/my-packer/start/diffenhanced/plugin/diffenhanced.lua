local a = vim.api

local sta

local do_diffenhanced
local diffenhanced_autocmd

local diffenhanced_loaded = nil
-- package.loaded['do_diffenhanced'] = nil

local init = function()
  if not diffenhanced_loaded then
    diffenhanced_loaded = true
    sta, do_diffenhanced = pcall(require, 'do_diffenhanced')
    if not sta then
      print(do_diffenhanced)
      return nil
    end
  end
  if diffenhanced_autocmd then
    a.nvim_del_autocmd(diffenhanced_autocmd)
    diffenhanced_autocmd = nil
  end
  return true
end

local diffenhanced = function()
  if not init() then
    return
  end
  pcall(do_diffenhanced.run)
end


diffenhanced_autocmd = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    diffenhanced()
  end,
})
