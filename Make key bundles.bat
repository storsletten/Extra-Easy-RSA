@echo off
SETLOCAL EnableDelayedExpansion
title Make key bundles
call Vars.bat
if not !errorlevel!==0 exit /b !errorlevel!

set "EASYRSA_PKI=!EASYRSA_PKI:/=\!"
set "BUNDLES=!EASYRSA_PKI!\bundles"
set "TLS_CRYPT_V2_CLIENTS=!EASYRSA_PKI!\tls-crypt-v2-clients"
set "TLS_CRYPT_V2_SERVERS=!EASYRSA_PKI!\tls-crypt-v2-servers"
set "EASYRSA_CERTS=!EASYRSA_PKI!\issued"
set "EASYRSA_KEYS=!EASYRSA_PKI!\private"

if not exist "!EASYRSA_CERTS!" (
 echo It looks like the PKI has not been initialized yet.
 echo Please run Shell.bat and initialize the PKI by typing: easyrsa init-pki
 pause
 exit /b 6
)

if not exist "!BUNDLES!" mkdir "!BUNDLES!"
if not exist "!BUNDLES!" (
 echo Cannot proceed without a "bundles" folder in !EASYRSA_PKI!
 pause
 exit /b 7
)

set found=0
for /f "tokens=*" %%F in ('findstr /m /c:"TLS Web Server Authentication" "!EASYRSA_CERTS!\*.crt" 2^>NUL') do (
 set /a found+=1
 set "CERT_NAME=%%~nF"
 set "BUNDLE=!BUNDLES!\!CERT_NAME!"
 if not exist "!BUNDLE!" mkdir "!BUNDLE!"
 copy "!EASYRSA_PKI!\ca.crt" "!BUNDLE!\" >NUL 2>NUL
 copy "!EASYRSA_PKI!\dh.pem" "!BUNDLE!\" >NUL 2>NUL
 copy "!EASYRSA_CERTS!\!CERT_NAME!.crt" "!BUNDLE!\" >NUL 2>NUL
 copy "!EASYRSA_KEYS!\!CERT_NAME!.key" "!BUNDLE!\" >NUL 2>NUL
 copy "!TLS_CRYPT_V2_SERVERS!\!CERT_NAME!.tls-crypt-v2.key" "!BUNDLE!\" >NUL 2>NUL
)

for /f "tokens=*" %%F in ('findstr /m /c:"TLS Web Client Authentication" "!EASYRSA_CERTS!\*.crt" 2^>NUL') do (
 set /a found+=1
 set "CERT_NAME=%%~nF"
 set "BUNDLE=!BUNDLES!\!CERT_NAME!"
 if not exist "!BUNDLE!" mkdir "!BUNDLE!"
 copy "!EASYRSA_PKI!\ca.crt" "!BUNDLE!\" >NUL 2>NUL
 copy "!EASYRSA_CERTS!\!CERT_NAME!.crt" "!BUNDLE!\" >NUL 2>NUL
 copy "!EASYRSA_KEYS!\!CERT_NAME!.key" "!BUNDLE!\" >NUL 2>NUL
 copy "!TLS_CRYPT_V2_CLIENTS!\!CERT_NAME!.*.tls-crypt-v2.key" "!BUNDLE!\" >NUL 2>NUL
)

if !found!==0 (
 echo Found no certificates in !EASYRSA_CERTS!
 pause
 exit /b 8
)

echo Total: !found!
echo The bundles can be found in !BUNDLES!
pause
