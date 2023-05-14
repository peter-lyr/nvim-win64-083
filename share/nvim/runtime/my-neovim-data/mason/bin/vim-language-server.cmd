@ECHO off
GOTO start
:find_dp0
SET dp0=%~dp0
EXIT /b
:start
SETLOCAL
CALL :find_dp0

endLocal & goto #_undefined_# 2>NUL || title %COMSPEC% & "%dp0%..\packages\vim-language-server\node_modules\.bin\vim-language-server.cmd" %*
