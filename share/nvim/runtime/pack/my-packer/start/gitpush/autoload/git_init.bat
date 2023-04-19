@echo off
echo %~0
set remote_path=%1

if exist %remote_path% (
	echo ------------------------------------
	echo remote path already existed: "%cd%\%remote_path%".
	echo ------------------------------------
	echo git remote -v:
	git remote -v
	echo ------------------------------------
	echo git branch -v:
	git branch -v
	echo ------------------------------------
  timeout /t 3
	exit /b
)

echo ====================================
echo Cur Dir:
echo         %cd%
md %remote_path%
cd %remote_path%
git init --bare
cd ..
git init
git reset
git add .gitignore
git commit -m ".gitignore"
git remote add origin %remote_path%
git branch -M "local_master"
git push -u origin "local_master"
timeout /t 3
