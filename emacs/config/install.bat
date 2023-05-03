@echo off

OpenFiles >nul 2>&1
if %errorLevel% == 0 (
    goto :gotAdmin
) else (
    net session >nul 2>&1
    if %errorLevel% == 0 (
        goto :gotAdmin
    ) else (
        echo Please run as administrator...
        pause
        exit /b
    )
)

:gotAdmin

:: Set HOME environment variable to userprofile if it doesn't exist
set HomeExists=false
for /f "usebackq tokens=1,* delims==" %%a in (`set HOME 2^>nul`) do (
    set HomeExists=true
)
if "!HomeExists!" == "false" (
    echo Creating HOME environment variable and targeting it to %USERPROFILE%
    setx HOME %USERPROFILE%
) else (
    echo HOME environment variable already exists. Not modifying the existing value.
)

:: Import DotFiles module and deploy manifest
cd /d "%~dp0"
powershell.exe -ExecutionPolicy Bypass -NoProfile -Command "Import-Module .\dotfiles.psm1; Deploy-Manifest .\MANIFEST"

pause
