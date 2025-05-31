@echo off
setlocal

:: Create 'temp' Directory
if not exist "%~dp0\bin\temp" mkdir "%~dp0\bin\temp"

:: Set Current Version Number
set /p current=<version.txt

:: Get Latest Version File
echo Comparing versions...
type NUL > "%~dp0\bin\temp\version_new.txt"
powershell -c "(Invoke-WebRequest -URI 'https://raw.githubusercontent.com/Lewwy95/modreign/main/version.txt').Content | Set-Content -Path '%~dp0\bin\temp\version_new.txt'"
cls

:: Set Latest Version Number
set /p new=<"%~dp0\bin\temp\version_new.txt"

:: Print Version Information
echo Checking for updates...
echo.
echo Current: v%current%
echo Latest: v%new%
timeout /t 2 /nobreak >nul
cls

:: Clear New Version File
del /s /q "%~dp0\bin\temp\version_new.txt"
cls

:: Check For Different Version Files
if %new% neq %current% (
    echo Update required! Downloading...
    timeout /t 2 /nobreak >nul
    cls
    goto download
)

:: Check For Install
if exist "%~dp0..\SeamlessCoop" goto launch

:: Not Installed
echo Not installed! Installing...
timeout /t 2 /nobreak >nul
cls
goto install

:: Downloader
:download
echo Downloading latest revision...
echo.
powershell -c "(New-Object System.Net.WebClient).DownloadFile('https://github.com/Lewwy95/modreign/archive/refs/heads/main.zip','%~dp0\bin\temp\modreign-main.zip')"
cls

:: Extract Latest Revision
echo Extracting latest revision...
powershell -c "Expand-Archive '%~dp0\bin\temp\modreign-main.zip' -Force '%~dp0\bin\temp'"
cls

:: Deploy Latest Revision
echo Deploying latest revision...
xcopy /s /y "%~dp0\bin\temp\modreign-main\*" "%~dp0"
cls

:: Apply New Version File
break>version.txt
powershell -c "(Invoke-WebRequest -URI 'https://raw.githubusercontent.com/Lewwy95/modreign/main/version.txt').Content | Set-Content -Path '%~dp0\version.txt'"
cls

:: Uninstall All Mods
:install
call "%~dp0\uninstall.bat"

:: Move New Mods
echo Installing mods...
if not exist "%~dp0..\SeamlessCoop" (
    :: Create and move the Seamless Coop and Mod Loader files and directories
    powershell -c "Expand-Archive '%~dp0\bin\SeamlessModLoader.zip' -Force '%~dp0\bin\temp'"
    xcopy /s /y /i "%~dp0\bin\temp\*" "%~dp0..\"
    del /s /q "%~dp0..\modreign-main.zip"
    rmdir /s /q "%~dp0..\modreign-main"
)
cls

:: Widescreen Checker
powershell.exe Get-WmiObject win32_videocontroller | find "CurrentHorizontalResolution" > resChecker.txt
powershell.exe Get-WmiObject win32_videocontroller | find "CurrentVerticalResolution" >> resChecker.txt
for /f "tokens=1-2 delims=^:^ " %%a in (resChecker.txt) do set %%a=%%b
if %CurrentHorizontalResolution% neq 3440 goto nowide
goto cleartemp

:: No Wide Install
:nowide
del /s /q "%~dp0..\mods\UnlockAspectRatio.dll"
cls

:: Clear 'temp' Folder
:cleartemp
echo Cleaning up...
del /s /q "%~dp0\bin\temp\*"
rmdir /s /q "%~dp0\bin\temp"
mkdir "%~dp0\bin\temp"
cls

:: Delete 'resChecker.txt'
del /s /q "%~dp0\resChecker.txt"
cls

:: Launch Game
:launch
echo This window will now launch the game.
echo Make sure you have the required game launch arguments set in Steam first!
echo.
echo Launching game...
pause
start "" "steam://rungameid/2622380"

:: Finish
endlocal
