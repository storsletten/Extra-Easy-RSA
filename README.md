# Extra Easy-RSA 3 on Windows with OpenVPN
This package makes it extra easy to generate certificates on Windows for use with OpenVPN.

## Installation
1. [Download OpenVPN](https://openvpn.net/community-downloads/) 2.5 or newer for Windows.
2. Make a custom installation of OpenVPN, and make sure Easy-RSA is being installed.
3. Clone or [download this repo as a zip file](https://github.com/tms88/Extra-Easy-RSA/archive/refs/heads/main.zip).

## Configuration
Easy RSA variables can be set in Vars.bat by opening it in a text editor.
For more details about which variables you can set and what they do, please see the vars.example file in the OpenVPN/easy-rsa folder.
Typically it's located in C:\Program Files\OpenVPN\easy-rsa\vars.example.

## Usage
Launch the EasyRSA Shell by invoking Shell.bat from this package.

To start a fresh PKI:
```sh
./easyrsa init-pki
```

To build the certificate authority:
```sh
./easyrsa build-ca nopass
```
Skip the nopass flag if you want the certificate to be password protected.

To build a server certificate:
```sh
./easyrsa build-server-full <name> nopass
```
Replace <name> with whatever you wish the certificate's common name to be.
Skip the nopass flag if you want the certificate to be password protected.

To build a client certificate:
```sh
./easyrsa build-client-full <name> nopass
```
Replace <name> with whatever you wish the certificate's common name to be.
Skip the nopass flag if you want the certificate to be password protected.

To generate Diffie-Hellman params:
```sh
./easyrsa gen-dh
```

To generate a static key for tls-crypt:
Invoke the file named Generate Static Key.bat from this package.

## Disclaimer
I am NOT affiliated to the Easy-RSA project or the OpenVPN project in any way.
I'm merely a user who wanted to try to simplify the process of building a PKI for my OpenVPN servers even further, and I make this package public in hope that others may find it useful too.
