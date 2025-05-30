@echo off
setlocal

:: Check For Install
if exist "%~dp0..\SeamlessCoop" (
    del /s /q "%~dp0..\mods\*"
    del /s /q "%~dp0..\SeamlessCoop\*"
    del /s /q "%~dp0..\dinput8.dll"
    del /s /q "%~dp0..\mod_loader.ini"
    del /s /q "%~dp0..\nrsc_launcher.exe"
    rmdir /s /q "%~dp0..\mods"
    rmdir /s /q "%~dp0..\SeamlessCoop"
)

:: Finish
endlocal
