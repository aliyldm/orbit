@echo off
cd /d "%~dp0"
if not exist "runtime\node.exe" (
  echo Tam Windows istemci paketini indirmeniz gerekiyor. runtime\node.exe eksik.
  pause
  exit /b 1
)
"runtime\node.exe" start-client.js
if errorlevel 1 pause
