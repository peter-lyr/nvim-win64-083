local a = vim.api

local sta

local do_fontsize
local fontsize_autocmd
local fontsize_loaded

-- package.loaded['do_fontsize'] = nil

local init = function()
  if not fontsize_loaded then
    fontsize_loaded = true
    sta, do_fontsize = pcall(require, 'do_fontsize')
    if not sta then
      print(do_fontsize)
      return nil
    end
  end
  if fontsize_autocmd then
    a.nvim_del_autocmd(fontsize_autocmd)
    fontsize_autocmd = nil
  end
  return true
end

local fontsize = function()
  if not init() then
    return
  end
end


fontsize_autocmd = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    fontsize()
  end,
})
