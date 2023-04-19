@echo off
echo %~0
echo %cd%
echo ------------------------------------
set res=
for /f "delims=" %%t in ('git status -s') do (
  set res=%res%%%t
)
if defined res (
  git status
) else (
  timeout /t 3
  exit /b
)
set var=
set /p var=commit info (Add all and push): 
if not defined var (
  timeout /t 3
  exit /b
)
set var2=
set /p var2=Sure to add all and push? (Empty for yes): 
if not defined var2 (
  git add -A
  echo ====================================
  git status
  echo ====================================
  git commit -m "%var%"
  git push
)
timeout /t 3
