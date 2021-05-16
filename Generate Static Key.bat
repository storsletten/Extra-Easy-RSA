@echo off
SETLOCAL EnableDelayedExpansion
title Generate Static OpenVPN Key
call Vars.bat
if not !errorlevel!==0 exit /b !errorlevel!

set "OPENVPN_STATIC_KEY=!EASYRSA_PKI!/static.key"
if not exist "!OPENVPN_STATIC_KEY!" goto createStaticKey
echo Static key already exists: !OPENVPN_STATIC_KEY!
choice /c yn /n /m "Do you wish to overwrite it with a new one? [Y/N]"
if !errorlevel!==1 goto createStaticKey
exit /b 4

:createStaticKey
echo Creating new static key: !OPENVPN_STATIC_KEY!
openvpn --genkey secret "!OPENVPN_STATIC_KEY!"
pause
ENDLOCAL
