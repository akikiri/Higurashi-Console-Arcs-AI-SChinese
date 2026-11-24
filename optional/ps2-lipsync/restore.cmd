@echo off
setlocal
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" -Restore %*
set "result=%errorlevel%"
pause
exit /b %result%
