@echo off
SETLOCAL EnableDelayedExpansion
title Generate tls-crypt-v2 client keys
call Vars.bat
if not !errorlevel!==0 exit /b !errorlevel!

set "OPENVPN_TLS_CRYPT_V2_CLIENTS=!EASYRSA_PKI:/=\!\tls-crypt-v2-clients"
set "OPENVPN_TLS_CRYPT_V2_SERVERS=!EASYRSA_PKI:/=\!\tls-crypt-v2-servers"

for %%S in ("!OPENVPN_TLS_CRYPT_V2_SERVERS!\*.tls-crypt-v2.key") do goto makeStuff
echo Found no compatible keys in "!OPENVPN_TLS_CRYPT_V2_SERVERS!"
echo Try generating tls-crypt-v2 server keys first.
pause
exit /b 6

:makeStuff
if not exist "!OPENVPN_TLS_CRYPT_V2_CLIENTS!" mkdir "!OPENVPN_TLS_CRYPT_V2_CLIENTS!"
if not exist "!OPENVPN_TLS_CRYPT_V2_CLIENTS!" (
 echo Cannot proceed without a tls-crypt-v2-clients folder in !EASYRSA_PKI!
 pause
 exit /b 7
)

set found=0
set created=0
for /f "tokens=*" %%C in ('findstr /m /c:"TLS Web Client Authentication" "!EASYRSA_PKI:/=\!\issued\*.crt" 2^>NUL') do (
 set /a found+=1
 for %%S in ("!OPENVPN_TLS_CRYPT_V2_SERVERS!\*.tls-crypt-v2.key") do (
  set "FILENAME=%%~nC.%%~nS.key"
  set "OPENVPN_TLS_CRYPT_V2_CLIENT_KEY=!OPENVPN_TLS_CRYPT_V2_CLIENTS!\!FILENAME!"
  set "OPENVPN_TLS_CRYPT_V2_SERVER_KEY=%%S"
  if not exist "!OPENVPN_TLS_CRYPT_V2_CLIENT_KEY!" (
   echo Creating !FILENAME!
   set /a created+=1
   openvpn --tls-crypt-v2 "!OPENVPN_TLS_CRYPT_V2_SERVER_KEY!" --genkey tls-crypt-v2-client "!OPENVPN_TLS_CRYPT_V2_CLIENT_KEY!"
  )
 )
)

if !found!==0 (
 echo Found no client certificates in !EASYRSA_PKI!/issued
 echo Build a client certificate and then try again.
 pause
 exit /b 7
)

if !created!==0 (
 echo Found no new client certificates to generate keys for.
 echo You'll find existing tls-crypt-v2-client keys in !OPENVPN_TLS_CRYPT_V2_CLIENTS!
 pause
 exit /b 8
)

echo Total: !created!
echo Folder: "!OPENVPN_TLS_CRYPT_V2_CLIENTS!"
pause
