@echo off
setlocal
cd /d "%~dp0"
set "ORBIT_NODE=%~dp0runtime\node.exe"
if not exist "%ORBIT_NODE%" set "ORBIT_NODE=node"
"%ORBIT_NODE%" "%~dp0distribution\launch-client.js"
if errorlevel 1 pause
