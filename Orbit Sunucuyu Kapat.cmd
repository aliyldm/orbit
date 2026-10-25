@echo off
setlocal
cd /d "%~dp0"
set "ORBIT_NODE=%~dp0runtime\node.exe"
if not exist "%ORBIT_NODE%" set "ORBIT_NODE=node"
if not exist "%~dp0DarkOrbit\local-server\logs\launcher-server.pid" (
 echo Bu paket tarafindan baslatilmis bir sunucu kaydi bulunamadi.
 pause
 exit /b 1
)
for /f "usebackq delims=" %%P in ("%~dp0DarkOrbit\local-server\logs\launcher-server.pid") do "%ORBIT_NODE%" "%~dp0DarkOrbit\local-server\tools\stop-server.js" %%P
if errorlevel 1 pause
