@echo off
setlocal
where powershell >nul 2>&1
if %errorlevel%==0 (
	powershell -NoProfile -ExecutionPolicy Bypass -File "app.ps1"
	exit /b
)
where pwsh >nul 2>&1
if %errorlevel%==0 (
	pwsh -NoProfile -ExecutionPolicy Bypass -File "app.ps1"
	exit /b
)
endlocal