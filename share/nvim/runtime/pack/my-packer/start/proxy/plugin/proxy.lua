local a = vim.api

local sta

local do_proxy
local proxy_autocmd
local proxy_loaded = nil

package.loaded['do_proxy'] = nil

local init = function()
  if not proxy_loaded then
    proxy_loaded = true
    sta, do_proxy = pcall(require, 'do_proxy')
    if not sta then
      print(do_proxy)
      return nil
    end
  end
  if proxy_autocmd then
    a.nvim_del_autocmd(proxy_autocmd)
    proxy_autocmd = nil
  end
  return true
end

local proxy = function(params)
  if not init() then
    return
  end
  pcall(do_proxy.run, params)
end


proxy_autocmd = a.nvim_create_autocmd({ 'CursorMoved', 'FocusLost', 'CursorHold' }, {
  callback = function()
    proxy()
  end,
})


a.nvim_create_user_command('ProxY', function(params)
  proxy(params['fargs'])
end, { nargs = '*', })

local s = vim.keymap.set
local opt = { silent = true }
s({ 'n', 'v' }, '<F6>z', ':<c-u>ProxY on<cr>', opt)
s({ 'n', 'v' }, '<F6>Z', ':<c-u>ProxY off<cr>', opt)
