# Extra Easy-RSA 3 on Windows with OpenVPN
This package aims to achieve the following :
- Make it extra easy to quickly set up your own PKI (Public Key Infrastructure).
- Make the PKI building environment portable-friendly, so that no customization is tied to a specific computer (beyond an OpenVPN installation).

## Installation
1. [Download OpenVPN](https://openvpn.net/community-downloads/) 2.5 or newer for Windows.
2. Make a custom installation of OpenVPN, and make sure Easy-RSA is being installed.
3. Clone or [download this repo as a zip file](https://github.com/tms88/Extra-Easy-RSA/archive/refs/heads/main.zip) and put it wherever you prefer (e.g. on a USB stick). By default, this is where your PKI will live.

## Configuration
Default values should be good for most users, but if you want to tinker with the config then you can set Easy RSA variables in the Vars.bat file.
For more details about which variables you can set and what they do, please see the vars.example file in the OpenVPN/easy-rsa folder.
Typically it's located in C:\Program Files\OpenVPN\easy-rsa\vars.example.

## Usage
Launch the EasyRSA Shell by invoking Shell.bat from this package.

If you're new to building a PKI, then here's a quick rundown of what's needed ():

### To start a fresh PKI:
```sh
./easyrsa init-pki
```

### To build the certificate authority:
```sh
./easyrsa build-ca nopass
```
Skip the nopass flag if you want the certificate to be password protected.

### To build a server certificate:
```sh
./easyrsa build-server-full "name" nopass
```
Replace "name" with whatever you wish the certificate's common name to be (for example my-home-network).
Skip the nopass flag if you want the certificate to be password protected.

### To build a client certificate:
```sh
./easyrsa build-client-full "name" nopass
```
Replace "name" with whatever you wish the certificate's common name to be (for example my-work-laptop).
Skip the nopass flag if you want the certificate to be password protected.

It is recommended that you build a unique certificate for every device.

### To generate Diffie-Hellman params for the server:
```sh
./easyrsa gen-dh
```

### To generate tls-crypt-v2 keys for OpenVPN:
Invoke the file named "Generate tls-crypt-v2 keys.bat" from this package.
It will perform the following tasks:
- Generate a tls-crypt-v2-serverr key for every server certificate in your PKI bundle.
- Generate tls-crypt-v2-client keys for every client certificate to match all the tls-crypt-v2-server keys.

Existing keys will not be overwritten, so you can safely run this script again after you make new certificates.

### To make key bundles
Invoke the file "Make key bundles.bat" if you want to automatically create a bundle with necessary files for each client and server.
These bundles can then be conveniently moved to every device that needs them.

## Disclaimer
I am NOT affiliated to the Easy-RSA project or the OpenVPN project in any way.
I'm merely a user who wanted to try to simplify the process of building a PKI for my OpenVPN servers even further, and I make this package public in hope that others may find it useful too.
