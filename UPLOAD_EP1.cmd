@echo off
setlocal
chcp 65001 >nul
cd /d "%~dp0"

echo =============================================
echo Beat-Between EP1 GitHub Uploader
echo Target: https://github.com/HHHHHOT/Beat-Between
echo =============================================
echo.

where git >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Git is not installed or not in PATH.
  echo Please install Git for Windows, then run this file again.
  pause
  exit /b 1
)

set "TMP=%TEMP%\Beat-Between-upload-%RANDOM%-%RANDOM%"
mkdir "%TMP%" >nul 2>nul

echo [1/5] Cloning your GitHub repository...
git clone "https://github.com/HHHHHOT/Beat-Between.git" "%TMP%\repo"
if errorlevel 1 goto :fail

cd /d "%TMP%\repo"
if not exist manga mkdir manga

echo [2/5] Copying Episode 1 PDF...
copy /Y "%~dp0manga\Beat_Between_EP1_Anchored_HQ.pdf" "manga\Beat_Between_EP1_Anchored_HQ.pdf" >nul
if errorlevel 1 goto :fail

for /f "delims=" %%A in ('git config user.name') do set "GITNAME=%%A"
if not defined GITNAME git config user.name "HHHHHOT"
for /f "delims=" %%A in ('git config user.email') do set "GITEMAIL=%%A"
if not defined GITEMAIL git config user.email "HHHHHOT@users.noreply.github.com"

echo [3/5] Creating commit...
git add "manga/Beat_Between_EP1_Anchored_HQ.pdf"
git diff --cached --quiet
if not errorlevel 1 (
  echo File is already up to date. Nothing new to commit.
) else (
  git commit -m "Add Beat Between Episode 1 anchored HQ PDF"
  if errorlevel 1 goto :fail
)

echo [4/5] Uploading to GitHub...
git push origin HEAD
if errorlevel 1 goto :fail

echo [5/5] Done.
echo.
echo Episode 1 has been uploaded to:
echo https://github.com/HHHHHOT/Beat-Between/blob/main/manga/Beat_Between_EP1_Anchored_HQ.pdf
echo.
start "" "https://github.com/HHHHHOT/Beat-Between"
rd /s /q "%TMP%" >nul 2>nul
pause
exit /b 0

:fail
echo.
echo [UPLOAD FAILED]
echo Keep this window open and send a screenshot to ChatGPT.
echo Temporary files are here: %TMP%
pause
exit /b 1
