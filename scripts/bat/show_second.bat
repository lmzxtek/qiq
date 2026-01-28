@echo off
set regkey=HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced
reg add "%regkey%" /v ShowSecondsInSystemClock /t REG_DWORD /d 1 /f >nul
taskkill /f /im explorer.exe & start explorer.exe