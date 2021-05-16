@echo off
SETLOCAL EnableDelayedExpansion
title EasyRSA Shell
call Vars.bat
if not !errorlevel!==0 exit /b !errorlevel!
pushd "!EASYRSA!"
bin\sh.exe bin/easyrsa-shell-init.sh
ENDLOCAL
