@echo off
title Uninstall
rd %appdata%\inbox /s /q || rem
if %errorlevel% equ 0 echo Done
pause