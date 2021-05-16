@echo off
set "EASYRSA_DN=cn_only"
set "EASYRSA_ALGO=rsa"
set "EASYRSA_KEY_SIZE=4096"
set "EASYRSA_CA_EXPIRE=3650"
set "EASYRSA_CERT_EXPIRE=3650"
set "EASYRSA_CRL_DAYS=3650"
set "EASYRSA_CERT_RENEW=3650"

rem Paths
if defined OPENVPN goto checkOPENVPN
for /F "tokens=2*" %%a IN ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\OpenVPN" /ve') do set "OPENVPN=%%b"
if not defined OPENVPN (
 echo Please make sure OpenVPN 2.5 or newer is installed.
 pause
 exit /b 1
)
:checkOPENVPN
if not exist "%OPENVPN%" (
 echo Cannot find OpenVPN program folder: %OPENVPN%
 echo Please make sure OpenVPN 2.5 or newer is installed.
 pause
 exit /b 2
)

rem Trim trailing backslash
if %OPENVPN:~-1%==\ set "OPENVPN=%OPENVPN:~0,-1%"

set "EASYRSA=%OPENVPN%\easy-rsa"
if not exist "%EASYRSA%" (
 echo Found no easy-rsa folder inside the OpenVPN program folder.
 echo Please make sure OpenVPN 2.5 or newer is installed with easy-rsa support.
 pause
 exit /b 3
)
if not exist "%EASYRSA%\bin\sh.exe" (
 echo It doesn't look like the OpenVPN installation has easy-rsa 3.
 echo Please make sure OpenVPN 2.5 or newer is installed with easy-rsa support.
 pause
 exit /b 4
)

set "EASYRSA_PKI=%~dp0PKI"

if exist "%EASYRSA_PKI%" goto addToPATH
echo PKI folder does not exist: %EASYRSA_PKI%
choice /c yn /n /m "Do you wish to create it now? [Y/N]"
if %errorlevel%==1 mkdir "%EASYRSA_PKI%"
if not exist "%EASYRSA_PKI%" exit /b 5

:addToPATH
set "PATH=%OPENVPN%\bin;%EASYRSA%\bin;%PATH%"

rem POSIX shell needs backslashes converted to forward slashes
set "EASYRSA=%EASYRSA:\=/%"
set "EASYRSA_PKI=%EASYRSA_PKI:\=/%"
