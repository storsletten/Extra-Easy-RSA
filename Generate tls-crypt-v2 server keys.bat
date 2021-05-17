@echo off
SETLOCAL EnableDelayedExpansion
title Generate tls-crypt-v2 server keys
call Vars.bat
if not !errorlevel!==0 exit /b !errorlevel!

set "OPENVPN_TLS_CRYPT_V2_SERVERS=!EASYRSA_PKI!/tls-crypt-v2-servers"
if not exist "!OPENVPN_TLS_CRYPT_V2_SERVERS!" mkdir "!OPENVPN_TLS_CRYPT_V2_SERVERS!"
if not exist "!OPENVPN_TLS_CRYPT_V2_SERVERS!" (
 echo Cannot proceed without a tls-crypt-v2-servers folder in !EASYRSA_PKI!
 pause
 exit /b 6
)

set found=0
set created=0
for /f "tokens=*" %%F in ('findstr /m /c:"TLS Web Server Authentication" "!EASYRSA_PKI:/=\!\issued\*.crt" 2^>NUL') do (
 set /a found+=1
 set "OPENVPN_TLS_CRYPT_V2_SERVER_KEY=!OPENVPN_TLS_CRYPT_V2_SERVERS!/%%~nF.tls-crypt-v2.key"
 if not exist "!OPENVPN_TLS_CRYPT_V2_SERVER_KEY!" (
  echo Creating %%~nF.tls-crypt-v2.key
  set /a created+=1
  openvpn --genkey tls-crypt-v2-server "!OPENVPN_TLS_CRYPT_V2_SERVER_KEY!"
 )
)

if !found!==0 (
 echo Found no server certificates in !EASYRSA_PKI!/issued
 echo Build a server certificate and then try again.
 pause
 exit /b 7
)

if !created!==0 (
 echo Found no new server certificates to generate keys for.
 echo You'll find existing tls-crypt-v2-server keys in !OPENVPN_TLS_CRYPT_V2_SERVERS!
 pause
 exit /b 8
)

echo Total: !created!
echo Folder: "!OPENVPN_TLS_CRYPT_V2_SERVERS!"
pause
