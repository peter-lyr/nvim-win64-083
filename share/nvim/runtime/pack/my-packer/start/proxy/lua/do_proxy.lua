local f = vim.fn

local M = {}

M.run = function(params)
  if not params or #params == 0 then
    return
  end
  if params[1] == 'on' then
    f['system']([[reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f]])
    print('proxe on')
  elseif params[1] == 'off' then
    f['system']([[reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f]])
    print('proxe off')
  end
end

return M
