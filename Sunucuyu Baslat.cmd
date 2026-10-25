@echo off
setlocal
title DarkOrbit Local Sunucu
cd /d "%~dp0DarkOrbit\local-server"
where node >nul 2>nul
if errorlevel 1 (
  echo Node.js bulunamadi. Node.js 26 veya ustunu yukleyin.
  pause
  exit /b 1
)
echo DarkOrbit Local Sunucu baslatiliyor...
echo Portal: http://127.0.0.1:8095
echo Sunucu hazir olduktan sonra DarkOrbit\DarkOrbit.exe dosyasini acabilirsiniz.
echo.
node server.js
echo.
echo Sunucu kapandi. Hata mesaji varsa yukarida gorebilirsiniz.
pause
