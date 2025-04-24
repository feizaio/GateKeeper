@echo off
:loop
taskkill /f /im Bentley.Licensing.Service.exe >nul 2>&1
timeout /t 5 >nul
goto loop