@ECHO off
GOTO start
:find_dp0
SET dp0=%~dp0
EXIT /b
:start
SETLOCAL
CALL :find_dp0

REM  endLocal & goto #_undefined_# 2>NUL || title %COMSPEC% & "D:\Desktop\nvim-win64-083\share\nvim\runtime\my-neovim-data\mason\packages\lua-language-server\bin/lua-language-server.exe" %*
endLocal & goto #_undefined_# 2>NUL || title %COMSPEC% & "C:\Users\llydr\Desktop\nvim-win64-083\share\nvim\runtime\my-neovim-data\mason\packages\lua-language-server\bin\lua-language-server.exe" %*
