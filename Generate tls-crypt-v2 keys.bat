@echo off
SETLOCAL EnableDelayedExpansion
title Generate tls-crypt-v2 keys
call Vars.bat
if not !errorlevel!==0 exit /b !errorlevel!

set "TLS_CRYPT_V2_CLIENTS=!EASYRSA_PKI:/=\!\tls-crypt-v2-clients"
set "TLS_CRYPT_V2_SERVERS=!EASYRSA_PKI:/=\!\tls-crypt-v2-servers"
set "EASYRSA_CERTS=!EASYRSA_PKI:/=\!\issued"

if not exist "!EASYRSA_CERTS!" (
 echo It looks like the PKI has not been initialized yet.
 echo Please run Shell.bat and initialize the PKI by typing: easyrsa init-pki
 pause
 exit /b 6
)

if not exist "!TLS_CRYPT_V2_CLIENTS!" mkdir "!TLS_CRYPT_V2_CLIENTS!"
if not exist "!TLS_CRYPT_V2_CLIENTS!" (
 echo Cannot proceed without a tls-crypt-v2-clients folder in !EASYRSA_PKI!
 pause
 exit /b 7
)

if not exist "!TLS_CRYPT_V2_SERVERS!" mkdir "!TLS_CRYPT_V2_SERVERS!"
if not exist "!TLS_CRYPT_V2_SERVERS!" (
 echo Cannot proceed without a tls-crypt-v2-servers folder in !EASYRSA_PKI!
 pause
 exit /b 8
)

set found=0
set created=0
for /f "tokens=*" %%F in ('findstr /m /c:"TLS Web Server Authentication" "!EASYRSA_CERTS!\*.crt" 2^>NUL') do (
 set /a found+=1
 set "FILENAME=%%~nF.tls-crypt-v2.key"
 set "TLS_CRYPT_V2_SERVER_KEY=!TLS_CRYPT_V2_SERVERS!\!FILENAME!"
 if not exist "!TLS_CRYPT_V2_SERVER_KEY!" (
  echo Creating !FILENAME!
  set /a created+=1
  openvpn --genkey tls-crypt-v2-server "!TLS_CRYPT_V2_SERVER_KEY!"
 )
)

if !found!==0 (
 echo Found no server certificates in !EASYRSA_CERTS!
 echo You can build a server certificate with the EasyRSA Shell by typing: easyrsa build-server-full "name" nopass
 echo Replace "name" with the name you want to give the certificate.
 pause
 exit /b 9
)

set found=0
for /f "tokens=*" %%C in ('findstr /m /c:"TLS Web Client Authentication" "!EASYRSA_CERTS!\*.crt" 2^>NUL') do (
 set /a found+=1
 for %%S in ("!TLS_CRYPT_V2_SERVERS!\*.tls-crypt-v2.key") do (
  set "FILENAME=%%~nC.%%~nS.key"
  set "TLS_CRYPT_V2_CLIENT_KEY=!TLS_CRYPT_V2_CLIENTS!\!FILENAME!"
  set "TLS_CRYPT_V2_SERVER_KEY=%%S"
  if not exist "!TLS_CRYPT_V2_CLIENT_KEY!" (
   echo Creating !FILENAME!
   set /a created+=1
   openvpn --tls-crypt-v2 "!TLS_CRYPT_V2_SERVER_KEY!" --genkey tls-crypt-v2-client "!TLS_CRYPT_V2_CLIENT_KEY!"
  )
 )
)

if !found!==0 (
 echo Found no client certificates in !EASYRSA_CERTS!
 echo You can build a client certificate with the EasyRSA Shell by typing: easyrsa build-client-full "name" nopass
 echo Replace "name" with the name you want to give the certificate.
 pause
 exit /b 10
)

echo Total created: !created!
echo Client keys: !TLS_CRYPT_V2_CLIENTS!
echo Server keys: !TLS_CRYPT_V2_SERVERS!
pause
