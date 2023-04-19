@echo off
echo ------------------------------------
echo %~0
echo %cd%
echo ------------------------------------
set /p var=Just push[yes/force]: 
if %var% EQU yes (
  git push
) else if %var% EQU force (
  git push -f
)
timeout /t 3
